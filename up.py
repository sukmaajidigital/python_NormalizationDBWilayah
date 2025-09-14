import os
import pandas as pd
from supabase import create_client, Client
from dotenv import load_dotenv
import time
import glob
import json

# Load konfigurasi dari .env
load_dotenv()
SUPABASE_URL = os.getenv("URL")
SUPABASE_KEY = os.getenv("service_role_key")

# Validasi konfigurasi
if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Error: Konfigurasi Supabase tidak ditemukan di file .env")
    print("   Pastikan file .env berisi URL dan service_role_key")
    exit(1)

try:
    # Inisialisasi client Supabase
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✅ Koneksi ke Supabase berhasil!")
except Exception as e:
    print(f"❌ Error koneksi ke Supabase: {e}")
    exit(1)

# Mapping primary key untuk setiap tabel
TABLE_PRIMARY_KEYS = {
    'provinsi': 'kode_provinsi',
    'provinsi_geo': 'kode_provinsi',
    'provinsi_luas': 'kode_provinsi',
    'provinsi_penduduk': 'kode_provinsi',
    'provinsi_pulau': 'kode_provinsi',
    'kabupaten_kota': 'kode_kabupaten_kota',
    'kabupaten_kota_geo': 'kode_kabupaten_kota',
    'kabupaten_kota_luas': 'kode_kabupaten_kota',
    'kabupaten_kota_penduduk': 'kode_kabupaten_kota',
    'kabupaten_kota_pulau': 'kode_kabupaten_kota',
    'kecamatan': 'kode_kecamatan',
    'desa_kelurahan': 'kode_desa_kelurahan',
    'pulau_locations': 'id'
}

def are_records_equal(record1, record2, exclude_keys=None):
    """
    Membandingkan dua record apakah identik atau tidak
    """
    if exclude_keys is None:
        exclude_keys = []
    
    # Convert to dict if needed and exclude specified keys
    r1 = {k: v for k, v in record1.items() if k not in exclude_keys}
    r2 = {k: v for k, v in record2.items() if k not in exclude_keys}
    
    # Handle None values and convert to comparable format
    for key in r1.keys():
        if r1[key] is None:
            r1[key] = ""
        if key in r2 and r2[key] is None:
            r2[key] = ""
        
        # Convert to string for comparison
        r1[key] = str(r1[key]).strip()
        if key in r2:
            r2[key] = str(r2[key]).strip()
    
    return r1 == r2

# Fungsi untuk melakukan upsert data dari CSV ke tabel Supabase
def upsert_csv_to_supabase(csv_file, table_name):
    try:
        print(f"\n📊 Membaca file {csv_file}...")
        df = pd.read_csv(csv_file)
        total_rows = len(df)
        print(f"   Ditemukan {total_rows} baris data")

        # Tentukan primary key untuk tabel ini
        primary_key = TABLE_PRIMARY_KEYS.get(table_name)
        if not primary_key:
            print(f"   ⚠️  Warning: Primary key tidak diketahui untuk tabel '{table_name}', menggunakan insert biasa")
            import_csv_to_supabase_simple(csv_file, table_name)
            return

        print(f"   🔑 Primary key: {primary_key}")

        # Batching
        BATCH_SIZE = 500
        data = df.to_dict(orient="records")
        total_batches = (total_rows + BATCH_SIZE - 1) // BATCH_SIZE

        insert_count = 0
        update_count = 0
        skip_count = 0
        error_count = 0

        print(f"� Memulai upsert ke tabel '{table_name}' dengan batch size {BATCH_SIZE}...")

        for batch_idx in range(total_batches):
            start = batch_idx * BATCH_SIZE
            end = min(start + BATCH_SIZE, total_rows)
            batch = data[start:end]
            batch_keys = [str(row[primary_key]) for row in batch]

            # Bulk select existing data hanya untuk batch
            try:
                existing_response = supabase.table(table_name).select("*").in_(primary_key, batch_keys).execute()
                existing_data = {str(row[primary_key]): row for row in existing_response.data}
            except Exception as e:
                print(f"   ⚠️  Error bulk select batch {batch_idx+1}: {e}")
                existing_data = {}

            # Siapkan batch untuk insert dan update
            to_insert = []
            to_update = []
            to_skip = 0

            for row in batch:
                clean_row = {k: (None if pd.isna(v) or v is None else v) for k, v in row.items()}
                pk_value = str(clean_row[primary_key])
                if pk_value in existing_data:
                    existing_row = existing_data[pk_value]
                    if are_records_equal(clean_row, existing_row, exclude_keys=['created_at', 'updated_at']):
                        to_skip += 1
                    else:
                        to_update.append(clean_row)
                else:
                    to_insert.append(clean_row)

            # Bulk insert
            if to_insert:
                try:
                    # Supabase bulk insert
                    supabase.table(table_name).insert(to_insert).execute()
                    insert_count += len(to_insert)
                    print(f"   ✅ Batch {batch_idx+1}/{total_batches}: {len(to_insert)} INSERT")
                except Exception as e:
                    error_count += len(to_insert)
                    print(f"   ❌ Batch {batch_idx+1}: Error bulk insert: {str(e)[:100]}...")

            # Bulk update
            if to_update:
                # Supabase tidak support bulk update, lakukan satu per satu (masih lebih efisien karena batch select)
                for row in to_update:
                    pk_value = str(row[primary_key])
                    try:
                        supabase.table(table_name).update(row).eq(primary_key, pk_value).execute()
                        update_count += 1
                    except Exception as e:
                        error_count += 1
                print(f"   🔄 Batch {batch_idx+1}/{total_batches}: {len(to_update)} UPDATE")

            if to_skip:
                skip_count += to_skip
                print(f"   ⏭️  Batch {batch_idx+1}/{total_batches}: {to_skip} SKIP")

            # Delay antar batch
            time.sleep(0.2)

        print(f"\n📈 Hasil upsert untuk tabel '{table_name}':")
        print(f"   ✅ Insert (baru): {insert_count} baris")
        print(f"   🔄 Update (berubah): {update_count} baris")
        print(f"   ⏭️  Skip (sama): {skip_count} baris")
        print(f"   ❌ Error: {error_count} baris")
        print(f"   📊 Total diproses: {total_rows} baris")

    except FileNotFoundError:
        print(f"❌ Error: File {csv_file} tidak ditemukan!")
    except Exception as e:
        print(f"❌ Error saat membaca file {csv_file}: {e}")

# Fungsi fallback untuk import biasa (jika primary key tidak diketahui)
def import_csv_to_supabase_simple(csv_file, table_name):
    try:
        print(f"📊 Membaca file {csv_file}...")
        df = pd.read_csv(csv_file)
        total_rows = len(df)
        
        data = df.to_dict(orient="records")
        success_count = 0
        error_count = 0
        
        for i, row in enumerate(data, 1):
            try:
                # Bersihkan nilai None
                clean_row = {}
                for k, v in row.items():
                    if pd.isna(v) or v is None:
                        clean_row[k] = None
                    else:
                        clean_row[k] = v
                
                response = supabase.table(table_name).insert(clean_row).execute()
                success_count += 1
                if i % 50 == 0:
                    print(f"   ✅ Baris {i}/{total_rows} berhasil diimport")
                
            except Exception as e:
                error_count += 1
                print(f"   ❌ Error pada baris {i}: {str(e)[:100]}...")
                
        print(f"\n📈 Hasil import:")
        print(f"   ✅ Berhasil: {success_count} baris")
        print(f"   ❌ Gagal: {error_count} baris")
        
    except Exception as e:
        print(f"❌ Error: {e}")

# Fungsi utama
def main():
    print("🚀 Memulai import CSV ke Supabase...")
    
    # Prompt user untuk memilih mode
    print("\nPilih mode operasi:")
    print("1. Proses semua file CSV")
    print("2. Proses file tertentu")
    
    mode = input("Masukkan pilihan (1 atau 2): ").strip()
    
    if mode == "2":
        # Mode file tertentu
        print("\nMasukkan nama file CSV (contoh: desa_kelurahan.csv):")
        specific_file = input("Nama file: ").strip()
        
        if not specific_file.endswith('.csv'):
            specific_file += '.csv'
        
        # Cari file di semua subdirektori
        found_files = []
        for root, dirs, files in os.walk('.'):
            if specific_file in files:
                found_files.append(os.path.join(root, specific_file))
        
        if not found_files:
            print(f"❌ File {specific_file} tidak ditemukan!")
            return
        
        if len(found_files) > 1:
            print(f"Ditemukan {len(found_files)} file dengan nama yang sama:")
            for i, file_path in enumerate(found_files, 1):
                print(f"{i}. {file_path}")
            
            choice = input("Pilih file (nomor): ").strip()
            try:
                selected_file = found_files[int(choice) - 1]
            except (ValueError, IndexError):
                print("❌ Pilihan tidak valid!")
                return
        else:
            selected_file = found_files[0]
        
        table_name = os.path.splitext(os.path.basename(selected_file))[0]
        print(f"\n🎯 Memproses file: {selected_file}")
        print(f"📋 Target tabel: {table_name}")
        
        upsert_csv_to_supabase(selected_file, table_name)
        
    else:
        # Mode semua file (default)
        csv_files = glob.glob("**/*.csv", recursive=True)
        
        if not csv_files:
            print("❌ Tidak ada file CSV yang ditemukan!")
            return
        
        print(f"\n� Ditemukan {len(csv_files)} file CSV:")
        for file in csv_files:
            print(f"   📄 {file}")
        
        confirm = input("\nLanjutkan proses import? (y/n): ").strip().lower()
        if confirm != 'y':
            print("❌ Proses dibatalkan")
            return
        
        # Proses setiap file CSV
        for csv_file in csv_files:
            table_name = os.path.splitext(os.path.basename(csv_file))[0]
            upsert_csv_to_supabase(csv_file, table_name)
            
            # Delay antar file untuk menghindari overload
            time.sleep(1)
    
    print("\n🎉 Proses selesai!")

# Main execution
if __name__ == "__main__":
    main()
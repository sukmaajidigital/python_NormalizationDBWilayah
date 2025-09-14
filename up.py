import os
import pandas as pd
from supabase import create_client, Client
from dotenv import load_dotenv
import time
import glob

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

# Fungsi untuk mengimpor data dari CSV ke tabel Supabase
def import_csv_to_supabase(csv_file, table_name):
    try:
        print(f"\n📊 Membaca file {csv_file}...")
        df = pd.read_csv(csv_file)
        total_rows = len(df)
        print(f"   Ditemukan {total_rows} baris data")

        data = df.to_dict(orient="records")
        success_count = 0
        error_count = 0
        
        print(f"🚀 Memulai import ke tabel '{table_name}'...")
        
        for i, row in enumerate(data, 1):
            try:
                response = supabase.table(table_name).insert(row).execute()
                success_count += 1
                print(f"   ✅ Baris {i}/{total_rows} berhasil diimport")
                
                
            except Exception as e:
                error_count += 1
                print(f"   ❌ Error pada baris {i}: {str(e)[:100]}...")
                
        print(f"\n📈 Hasil import untuk tabel '{table_name}':")
        print(f"   ✅ Berhasil: {success_count} baris")
        print(f"   ❌ Gagal: {error_count} baris")
        print(f"   📊 Total: {total_rows} baris")
        
    except FileNotFoundError:
        print(f"❌ Error: File {csv_file} tidak ditemukan!")
    except Exception as e:
        print(f"❌ Error saat membaca file {csv_file}: {e}")

# Main execution
if __name__ == "__main__":
    print("🔄 Memulai proses import data ke Supabase...")
    
    # Import semua file CSV dari subfolder ke tabel dengan nama yang sama

    # Dapatkan semua file CSV di subfolder (misal: data/*.csv, geo/*.csv, dll)
    csv_files = glob.glob("**/*.csv", recursive=True)

    if not csv_files:
        print("❌ Tidak ada file CSV ditemukan di subfolder!")
    else:
        for csv_file in csv_files:
            # Nama tabel diambil dari nama file tanpa ekstensi
            table_name = os.path.splitext(os.path.basename(csv_file))[0]
            import_csv_to_supabase(csv_file, table_name)
    
    print("\n🎉 Proses import selesai!")
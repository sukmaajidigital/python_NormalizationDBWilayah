/*
BISMILLAAHIRRAHMAANIRRAHIIM - In the Name of Allah, Most Gracious, Most Merciful
================================================================================
filename : provinsi.sql
purpose  : Normalized provinsi data
note     : Data Provinsi sesuai Kepmendagri No 300.2.2-2138 Tahun 2025
create   : 2025-09-13
author   : sukmaajidigital
================================================================================
*/

-- Table structure for provinsi

CREATE TABLE IF NOT EXISTS provinsi (
    kode_provinsi VARCHAR(2) PRIMARY KEY,
    nama_provinsi VARCHAR(100) NOT NULL
);
CREATE INDEX idx_provinsi_nama ON provinsi (nama_provinsi);

-- Data for table provinsi
INSERT INTO provinsi (kode_provinsi, nama_provinsi) VALUES
('11', 'Aceh'),
('12', 'Sumatera Utara'),
('13', 'Sumatera Barat'),
('14', 'Riau'),
('15', 'Jambi'),
('16', 'Sumatera Selatan'),
('17', 'Bengkulu'),
('18', 'Lampung'),
('19', 'Kepulauan Bangka Belitung'),
('21', 'Kepulauan Riau'),
('31', 'Daerah Khusus Ibukota Jakarta'),
('32', 'Jawa Barat'),
('33', 'Jawa Tengah'),
('34', 'Daerah Istimewa Yogyakarta'),
('35', 'Jawa Timur'),
('36', 'Banten'),
('51', 'Bali'),
('52', 'Nusa Tenggara Barat'),
('53', 'Nusa Tenggara Timur'),
('61', 'Kalimantan Barat'),
('62', 'Kalimantan Tengah'),
('63', 'Kalimantan Selatan'),
('64', 'Kalimantan Timur'),
('65', 'Kalimantan Utara'),
('71', 'Sulawesi Utara'),
('72', 'Sulawesi Tengah'),
('73', 'Sulawesi Selatan'),
('74', 'Sulawesi Tenggara'),
('75', 'Gorontalo'),
('76', 'Sulawesi Barat'),
('81', 'Maluku'),
('82', 'Maluku Utara'),
('91', 'Papua'),
('92', 'Papua Barat'),
('93', 'Papua Selatan'),
('94', 'Papua Tengah'),
('95', 'Papua Pegunungan'),
('96', 'Papua Barat Daya');

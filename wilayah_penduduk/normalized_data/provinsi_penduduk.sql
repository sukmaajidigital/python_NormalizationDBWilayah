/*
BISMILLAAHIRRAHMAANIRRAHIIM - In the Name of Allah, Most Gracious, Most Merciful
================================================================================
filename : provinsi_penduduk.sql
purpose  : Normalized provinsi_penduduk data from Kemendagri
note     : Data Provinsi_Penduduk sesuai Kepmendagri No 300.2.2-2138 Tahun 2025
           Data penduduk per wilayah berdasar data terbaru
create   : 2025-09-13
author   : sukmaajidigital with GitHub Copilot (normalized from original data)
================================================================================
*/

-- Table structure for provinsi_penduduk

CREATE TABLE IF NOT EXISTS provinsi_penduduk (
    kode_provinsi VARCHAR(2) PRIMARY KEY,
    nama_provinsi VARCHAR(100) NOT NULL,
    penduduk_pria BIGINT NOT NULL DEFAULT 0,
    penduduk_wanita BIGINT NOT NULL DEFAULT 0,
    penduduk_total BIGINT NOT NULL DEFAULT 0
);
CREATE INDEX idx_provinsi_penduduk_nama ON provinsi_penduduk (nama_provinsi);
CREATE INDEX idx_provinsi_penduduk_total ON provinsi_penduduk (penduduk_total);

-- Data for table provinsi_penduduk
INSERT INTO provinsi_penduduk (kode_provinsi, nama_provinsi, penduduk_pria, penduduk_wanita, penduduk_total) VALUES
('11', 'Aceh', 2815060, 2808419, 5623479),
('12', 'Sumatera Utara', 7828098, 7812807, 15640905),
('13', 'Sumatera Barat', 2923132, 2897227, 5820359),
('14', 'Riau', 3625379, 3473918, 7099297),
('15', 'Jambi', 1952872, 1881567, 3834439),
('16', 'Sumatera Selatan', 4616445, 4448245, 9064690),
('17', 'Bengkulu', 1086715, 1041242, 2127957),
('18', 'Lampung', 4668816, 4475447, 9144263),
('19', 'Kepulauan Bangka Belitung', 794861, 754701, 1549562),
('21', 'Kepulauan Riau', 1155100, 1116790, 2271890),
('31', 'Daerah Khusus Ibukota Jakarta', 5537335, 5500881, 11038216),
('32', 'Jawa Barat', 25997794, 25318584, 51316378),
('33', 'Jawa Tengah', 19340389, 19090256, 38430645),
('34', 'Daerah Istimewa Yogyakarta', 1853487, 1889878, 3743365),
('35', 'Jawa Timur', 20894359, 21025547, 41919906),
('36', 'Banten', 6543019, 6338355, 12881374),
('51', 'Bali', 2193831, 2181432, 4375263),
('52', 'Nusa Tenggara Barat', 2870780, 2880515, 5751295),
('53', 'Nusa Tenggara Timur', 2850092, 2850680, 5700772),
('61', 'Kalimantan Barat', 2902699, 2743569, 5646268),
('62', 'Kalimantan Tengah', 1459913, 1365377, 2825290),
('63', 'Kalimantan Selatan', 2176733, 2128548, 4305281),
('64', 'Kalimantan Timur', 2138665, 1984638, 4123303),
('65', 'Kalimantan Utara', 403628, 366999, 770627),
('71', 'Sulawesi Utara', 1351734, 1293557, 2645291),
('72', 'Sulawesi Tengah', 1652891, 1566603, 3219494),
('73', 'Sulawesi Selatan', 4729375, 4798901, 9528276),
('74', 'Sulawesi Tenggara', 1427378, 1397211, 2824589),
('75', 'Gorontalo', 631495, 619465, 1250960),
('76', 'Sulawesi Barat', 744533, 722208, 1466741),
('81', 'Maluku', 969012, 966574, 1935586),
('82', 'Maluku Utara', 729780, 664451, 1394231),
('91', 'Papua', 574173, 528187, 1102360),
('92', 'Papua Barat', 297017, 279238, 576255),
('93', 'Papua Selatan', 292552, 269668, 562220),
('94', 'Papua Tengah', 723511, 645601, 1369112),
('95', 'Papua Pegunungan', 786734, 683784, 1470518),
('96', 'Papua Barat Oaya', 324005, 299181, 623186);

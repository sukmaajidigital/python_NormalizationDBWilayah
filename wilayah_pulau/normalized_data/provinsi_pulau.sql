/*
BISMILLAAHIRRAHMAANIRRAHIIM - In the Name of Allah, Most Gracious, Most Merciful
================================================================================
filename : provinsi_pulau.sql
purpose  : Normalized provinsi_pulau data from pulau (island) dataset
note     : Data Provinsi_Pulau - Island/Pulau geographic locations
           Contains coordinate data for islands across Indonesia
create   : 2025-09-13
author   : sukmaajidigital with GitHub Copilot (normalized from original data)
================================================================================
*/

-- Table structure for provinsi_pulau

CREATE TABLE IF NOT EXISTS provinsi_pulau (
    kode_provinsi VARCHAR(2) PRIMARY KEY,
    nama_provinsi VARCHAR(100) NOT NULL
);
CREATE INDEX idx_provinsi_pulau_nama ON provinsi_pulau (nama_provinsi);

-- Data for table provinsi_pulau
INSERT INTO provinsi_pulau (kode_provinsi, nama_provinsi) VALUES
('11', 'Provinsi 11'),
('12', 'Provinsi 12'),
('13', 'Provinsi 13'),
('14', 'Provinsi 14'),
('15', 'Provinsi 15'),
('16', 'Provinsi 16'),
('17', 'Provinsi 17'),
('18', 'Provinsi 18'),
('19', 'Provinsi 19'),
('21', 'Provinsi 21'),
('31', 'Provinsi 31'),
('32', 'Provinsi 32'),
('33', 'Provinsi 33'),
('34', 'Provinsi 34'),
('35', 'Provinsi 35'),
('36', 'Provinsi 36'),
('51', 'Provinsi 51'),
('52', 'Provinsi 52'),
('53', 'Provinsi 53'),
('61', 'Provinsi 61'),
('62', 'Provinsi 62'),
('63', 'Provinsi 63'),
('64', 'Provinsi 64'),
('65', 'Provinsi 65'),
('71', 'Provinsi 71'),
('72', 'Provinsi 72'),
('73', 'Provinsi 73'),
('74', 'Provinsi 74'),
('75', 'Provinsi 75'),
('76', 'Provinsi 76'),
('81', 'Provinsi 81'),
('82', 'Provinsi 82'),
('91', 'Provinsi 91'),
('92', 'Provinsi 92'),
('93', 'Provinsi 93'),
('94', 'Provinsi 94'),
('96', 'Provinsi 96');

-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.desa_kelurahan (
  kode_desa_kelurahan text NOT NULL,
  kode_kecamatan text,
  kode_kabupaten_kota double precision,
  kode_provinsi bigint,
  nama_desa_kelurahan text,
  CONSTRAINT desa_kelurahan_pkey PRIMARY KEY (kode_desa_kelurahan)
);
CREATE TABLE public.kabupaten_kota (
  kode_kabupaten_kota double precision NOT NULL,
  kode_provinsi bigint,
  nama_kabupaten_kota text,
  CONSTRAINT kabupaten_kota_pkey PRIMARY KEY (kode_kabupaten_kota)
);
CREATE TABLE public.kabupaten_kota_geo (
  kode_kabupaten_kota text NOT NULL,
  kode_provinsi text,
  nama_kabupaten_kota text,
  ibukota text,
  lat text,
  lng text,
  elv text,
  tz text,
  luas text,
  penduduk text,
  path text,
  status text,
  CONSTRAINT kabupaten_kota_geo_pkey PRIMARY KEY (kode_kabupaten_kota)
);
CREATE TABLE public.kabupaten_kota_luas (
  kode_kabupaten_kota double precision NOT NULL,
  kode_provinsi bigint,
  nama_kabupaten_kota text,
  luas double precision,
  CONSTRAINT kabupaten_kota_luas_pkey PRIMARY KEY (kode_kabupaten_kota)
);
CREATE TABLE public.kabupaten_kota_penduduk (
  kode_kabupaten_kota double precision NOT NULL,
  kode_provinsi bigint,
  nama_kabupaten_kota text,
  penduduk_pria bigint,
  penduduk_wanita bigint,
  penduduk_total bigint,
  CONSTRAINT kabupaten_kota_penduduk_pkey PRIMARY KEY (kode_kabupaten_kota)
);
CREATE TABLE public.kabupaten_kota_pulau (
  kode_kabupaten_kota double precision NOT NULL,
  kode_provinsi bigint,
  nama_kabupaten_kota text,
  CONSTRAINT kabupaten_kota_pulau_pkey PRIMARY KEY (kode_kabupaten_kota)
);
CREATE TABLE public.kecamatan (
  kode_kecamatan text NOT NULL,
  kode_kabupaten_kota double precision,
  kode_provinsi bigint,
  nama_kecamatan text,
  CONSTRAINT kecamatan_pkey PRIMARY KEY (kode_kecamatan)
);
CREATE TABLE public.provinsi (
  kode_provinsi bigint NOT NULL,
  nama_provinsi text,
  CONSTRAINT provinsi_pkey PRIMARY KEY (kode_provinsi)
);
CREATE TABLE public.provinsi_geo (
  kode_provinsi text NOT NULL,
  nama_provinsi text,
  ibukota text,
  lat text,
  lng text,
  elv text,
  tz text,
  luas text,
  penduduk text,
  path text,
  status text,
  CONSTRAINT provinsi_geo_pkey PRIMARY KEY (kode_provinsi)
);
CREATE TABLE public.provinsi_luas (
  kode_provinsi bigint NOT NULL,
  nama_provinsi text,
  luas double precision,
  CONSTRAINT provinsi_luas_pkey PRIMARY KEY (kode_provinsi)
);
CREATE TABLE public.provinsi_penduduk (
  kode_provinsi bigint NOT NULL,
  nama_provinsi text,
  penduduk_pria bigint,
  penduduk_wanita bigint,
  penduduk_total bigint,
  CONSTRAINT provinsi_penduduk_pkey PRIMARY KEY (kode_provinsi)
);
CREATE TABLE public.provinsi_pulau (
  kode_provinsi bigint NOT NULL,
  nama_provinsi text,
  CONSTRAINT provinsi_pulau_pkey PRIMARY KEY (kode_provinsi)
);
CREATE TABLE public.pulau_locations (
  id bigint NOT NULL,
  kode_pulau text,
  nama_pulau text,
  kode_provinsi bigint,
  kode_kabupaten_kota double precision,
  latitude double precision,
  longitude double precision,
  notes text,
  CONSTRAINT pulau_locations_pkey PRIMARY KEY (id)
);
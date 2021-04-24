drop database pemesanan;

create database pemesanan;

use pemesanan;

create table pembeli (
	kode_beli	varchar(4) primary key,
	nama_beli	varchar(50),
	alamat_beli	varchar(25),
	kel_beli	varchar(25),
	kec_beli	varchar(25),
	kota_beli	varchar(25),
	prop_beli	varchar(25)
);

create table pegawai (
	kode_pgw	varchar(4) primary key,
	nama_pgw	varchar(50),
	alamat_pgw	varchar(25),
	kel_pgw	varchar(25),
	kec_pgw	varchar(25),
	kota_pgw	varchar(25),
	prop_pgw	varchar(25)
);

create table barang (
	kode_barang	varchar(4) primary key,
	nama_barang	varchar(50),
	satuan_barang	varchar(25),
	harga_barang	varchar(25)
);

create table pesandetail (
	no_pesan 	varchar(4),
	kode_barang	varchar(4),
	jml_barang	tinyint,
	primary key (no_pesan, kode_barang),
	constraint fk_pesandetail_2_barang 
		foreign key (kode_barang) 
		references barang (kode_barang)
);

create table pesanheader (
	no_pesan	varchar(4),
	tgl_pesan	date,
	kode_beli	varchar(4),
	kode_pgw	varchar(4),
	cttn_terimabarang 	varchar(25),
	cttn_bayarbarang	varchar(25),
	cttn_kirimbon	varchar(25),
	primary key (no_pesan, tgl_pesan, kode_pgw, kode_beli),
	constraint fk_pesanheader_2_pembeli 
		foreign key (kode_beli) 
		references pembeli (kode_beli),
	constraint fk_pesanheader_2_pegawai 
		foreign key (kode_pgw) 
		references pegawai (kode_pgw),
	constraint fk_pesanheader_2_pesandetail 
		foreign key (no_pesan) 
		references pesandetail (no_pesan)
);


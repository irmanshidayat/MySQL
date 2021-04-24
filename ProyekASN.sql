DROP DATABASE pns;
CREATE DATABASE pns;

USE pns;

CREATE TABLE pegawai (
	nip VARCHAR(18) PRIMARY KEY,
	nama VARCHAR(5)
);

DELIMITER ;;
CREATE PROCEDURE sp_ins_pegawai (
	m_nip VARCHAR(18),  /* perhatikan bagian ini nama kolom CREATE PROCEDURE tidak boleh sama dengan kolom CREATE TABLE diatas */
	m_nama VARCHAR (5)
)

BEGIN
		INSERT INTO pegawai VALUES
		(m_nip, m_nama); /* mengikuti CREATE PROCEDURE */
		SELECT nip, nama   /* mengikuti CREATE TABLE */
		FROM pegawai;
END;;
DELIMITER ;

CALL sp_ins_pegawai ('197209172005011002','Irman');
CALL sp_ins_pegawai ('198201312010052001','Ica');
CALL sp_ins_pegawai ('200901202015071004','Angga');
CALL sp_ins_pegawai ('201507142019031002','Reka');
CALL sp_ins_pegawai ('201411142020102003','Rohmah');

-- untuk menambah kolom /* dari sini */
ALTER TABLE pegawai
	ADD agama VARCHAR(11);

DELIMITER ;;
CREATE PROCEDURE sp_agama(
	m_agama_pgw VARCHAR(5),
	m_nip_pgw VARCHAR(18)
)

BEGIN
	   	UPDATE pegawai
		SET agama = m_agama_pgw
		WHERE nip = m_nip_pgw;
END;;
DELIMITER ;

CALL sp_agama('Islam', '197209172005011002');
CALL sp_agama('Islam', '198201312010052001');
CALL sp_agama('Islam', '200901202015071004');
CALL sp_agama('Islam', '201507142019031002');
CALL sp_agama('Islam', '201411142020102003');				
/* sampai sini */

-- pembatas

CREATE VIEW vw_info_pgw AS
	SELECT
			nip,
			nama,
			DATE_FORMAT(LEFT(nip,8),"%W, %D, %M, %Y") AS Lahir,
			DATE_FORMAT(CONCAT(MID(nip,9,6),"01"),"%M, %Y") AS Pengangkatan,	
			IF(MID(nip,15,1) = "1", "Pria", "Wanita") AS JenisKelamin,
			RIGHT(nip,3) AS NoUrut
	FROM 	pegawai;



DELIMITER ;;
-- PROCEDURE digunakan untuk pencarian data
CREATE PROCEDURE sp_info_pgw_jnskel (
	m_jns_kel VARCHAR(6)
)
BEGIN
		SELECT	nama,
				JenisKelamin
		FROM 	vw_info_pgw
		WHERE	JenisKelamin = m_jns_kel;
END;;
DELIMITER ;

--  CREATE PROCEDURE manggil nya pakai CALL
CALL	sp_info_pgw_jnskel('Wanita');
CALL	sp_info_pgw_jnskel('Pria');

-- pembatas

CREATE TABLE agama (
	kode_agama VARCHAR(1) PRIMARY KEY,
	nama_agama VARCHAR(11)
);


DELIMITER ;;
CREATE PROCEDURE sp_ins_agamaku (
	m_kode_agama VARCHAR(1),  /* perhatikan bagian ini nama kolom CREATE PROCEDURE tidak boleh sama dengan kolom CREATE TABLE diatas */
	m_nama_agama VARCHAR (11)
)

BEGIN
		INSERT INTO agama VALUES
		(m_kode_agama, m_nama_agama); /* mengikuti CREATE PROCEDURE */
		SELECT m_nama_agama, m_nama_agama    /* mengikuti CREATE TABLE */ 
		FROM agama;
END;;
DELIMITER ;

-- CALL sp_ins_agamaku (1,'Islam');
-- CALL sp_ins_agamaku (2,'Katolik');
-- CALL sp_ins_agamaku (3,'Protestan');
-- CALL sp_ins_agamaku (4,'Hindu');
-- CALL sp_ins_agamaku (5,'Budha');
-- CALL sp_ins_agamaku (6,'Kepercayaan');


DELIMITER ;;
CREATE PROCEDURE sp_ins_agama(
	m_jml_agama TINYINT
)
BEGIN
  DECLARE ulang TINYINT;
  SET ulang = 1;
  WHILE ulang <= m_jml_agama Do
  		INSERT INTO agama VALUES (
  			CONVERT(ulang, CHAR),
  			elt(ulang, 'Islam', 'Katolik', 'Protestan', 'Hindu', 'Budha', 'Kepercayaan')
  		);
  		SET ulang = ulang + 1;
  		END WHILE;
  		SELECT *
  		FROM agama;
END;;
DELIMITER ;

CALL sp_ins_agama(6);

ALTER TABLE pegawai
	DROP agama;

ALTER TABLE pegawai
	ADD COLUMN kode_agama_pgw VARCHAR(1);

ALTER TABLE pegawai
	ADD CONSTRAINT fk_pegawai_2_agama
		FOREIGN KEY(kode_agama_pgw)
		REFERENCES agama(kode_agama);

DELIMITER ;;
CREATE PROCEDURE sp_agama2(
	m_kode_agama VARCHAR(1),
	nip_pgw VARCHAR(18)
)

BEGIN
	   	UPDATE pegawai
		SET kode_agama_pgw = m_kode_agama
		WHERE nip = nip_pgw;

CREATE VIEW IF NOT EXISTS vw_pgw AS
SELECT 	nip,
		nama,
		nama_agama
FROM 	pegawai AS p, agama AS a
WHERE	p.kode_agama_pgw = a.kode_agama; /* menggunakan WHERE dapat lintas tabel, perhatikan tabel pegawai dan agama */
END;;
DELIMITER ;

CALL sp_agama2('1', '197209172005011002');
CALL sp_agama2('2', '198201312010052001');
CALL sp_agama2('3', '200901202015071004');
CALL sp_agama2('4', '201507142019031002');
CALL sp_agama2('5', '201411142020102003');	

-- pembatas

DELIMITER ;;
CREATE PROCEDURE sp_ins_pegawai_baru(
		m_nip_pgw VARCHAR(18),
		m_nama_pgw VARCHAR(12),
		m_kode_agama VARCHAR(1)
)

BEGIN
	INSERT INTO pegawai VALUES
	(m_nip_pgw, m_nama_pgw, m_kode_agama);

	SELECT * FROM agama;

END;;
DELIMITER ;

CALL sp_ins_pegawai_baru('198208182001031002', 'Lelita', '2');
CALL sp_ins_pegawai_baru('197202202002012001', 'Monica', '3');
CALL sp_ins_pegawai_baru('201006212013041004', 'Fani', '5');
CALL sp_ins_pegawai_baru('201304132014071002', 'Asri', '4');
CALL sp_ins_pegawai_baru('201210162017102003', 'Rima', '6');	


ALTER VIEW vw_info_pgw AS  /* daripada membuat DROP lebih baik menggunakan ALTER, karena sama saja seperti membuat baru */
	SELECT
			nama,
			nip,
			DATE_FORMAT(LEFT(nip,8),"%W, %D, %M, %Y") AS Lahir,
			YEAR(CURDATE()) - YEAR(LEFT(nip,8)) AS usia1,
			/* untuk mencari usia juga bisa digunakan kodingan dibawah ini */
			TIMESTAMPDIFF(YEAR, LEFT(nip,8), CURDATE()) AS umur2, /* sampai baris ini untuk usia */
			DATE_FORMAT(CONCAT(MID(nip,9,6),"01"),"%M, %Y") AS Pengangkatan,	
			IF(MID(nip,15,1) = "1", "Pria", "Wanita") AS JenisKelamin,
			RIGHT(nip,3) AS NoUrut,
			nama_agama
	FROM 	pegawai AS p, agama AS a
	WHERE	p.kode_agama_pgw = a.kode_agama;

-- pembatas


-- CREATE PROCEDURE sp_ins_pegawai_umur
-- 	SELECT	nip,
-- 			nama,

-- 			DATE_FORMAT(CONCAT(LEFT(nip,8)), "%W, %d %M %Y")
-- 			AS tgl_lahir_2,

-- 			YEAR(CURDATE()) - YEAR(LEFT(nip,8)) AS usia,

-- 			DATE_FORMAT(CONCAT(MID(nip,9,6),"01"), "%M %Y")
-- 			AS tgl_lahir_2,

-- 			IF(NID(nip,15,1)="1","Pria","Wanita") AS jns_kel,
-- 			RIGHT(nip,3) AS nomer_urut,
-- 			list_agama

-- 			FROM pegawai, agama
-- 			WHERE pegawai.kode = agama.kode;

-- 	SELECT YEAR(CURDATE()) - YEAR(tgl_lahir_2) AS usia FROM vw_ins_pegawai_umur;























-- DELIMITER ;;
-- CREATE PROCEDURE sp_agama3(
-- 	m_kode_agama VARCHAR(1),
-- 	nip_pgw VARCHAR(18)
-- )

-- BEGIN
-- 	   	UPDATE pegawai
-- 		SET kode_agama_pgw = m_kode_agama
-- 		WHERE nip = nip_pgw;
  
-- SELECT 	nip,
-- 		nama,
-- 		nama_agama
-- FROM 	pegawai AS p, agama AS a
-- WHERE	p.kode_agama_pgw = a.kode_agama;  menggunakan WHERE dapat lintas tabel, perhatikan tabel pegawai dan agama 
-- END;;
-- DELIMITER ;

-- CALL sp_agama3('1', '197209172005011002');
-- CALL sp_agama3('2', '198201312010052001');
-- CALL sp_agama3('3', '200901202015071004');
-- CALL sp_agama3('4', '201507142019031002');
-- CALL sp_agama3('5', '201411142020102003');	


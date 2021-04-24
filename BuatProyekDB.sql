CREATE DATABASE IF NOT EXISTS book1;

USE book1;

/*DROP TABLE untuk menghapus tabel yang salah*/

CREATE TABLE IF NOT EXISTS sheet1(
	saklar_lampu VARCHAR(3)
);

-- INSERT INTO sheet1 VALUES
-- 	('ON'),
-- 	('OFF');	

/*gunakan satu persatu tiap codingan jika ingin import di MySQL*/
-- DELETE FROM sheet1;

-- ALTER TABLE sheet1
-- 	ADD PRIMARY KEY(saklar_lampu);

-- ALTER TABLE sheet1
-- 	DROP PRIMARY KEY;


-- -- memasukkan 2 record sekaligus
-- INSERT INTO sheet1 (saklar_lampu)  Jika ingin membuat komen di tengah2 code  VALUES
-- 	('ON'),
-- 	('OFF');


/*Debug untuk jumlah record*/
SELECT 
		saklar_lampu as 'Nama Saklar Lampu', /* bisa juga dengan as 'Nama Saklar Lampup' +tidak disarankan menggunakan ini+ */
		COUNT(saklar_lampu) as Status_Saklar_Lampu
FROM sheet1
GROUP BY saklar_lampu
ORDER BY saklar_lampu ASC;

SELECT  saklar_lampu AS 'SAKLAR LAMPU',
		IF(saklar_lampu='ON','Nyala','Mati') AS STATUS_LAMPU
FROM sheet1;


-- pembatas


CREATE TABLE IF NOT EXISTS sheet2(
	Lampu_Lalulintas VARCHAR(6)
);

-- INSERT INTO sheet2 VALUES
-- 	('MERAH'),
-- 	('KUNING'),
-- 	('HIJAU');

-- ALTER TABLE sheet2
-- 	ADD PRIMARY KEY(Lampu_Lalulintas);

SELECT  
		Lampu_Lalulintas AS LAMPU,
		IF(Lampu_Lalulintas='MERAH',
			'Berhenti', 
			IF(Lampu_Lalulintas="Kuning",
				"Berhati-hati",
				"Berjalan"
			   )
		   ) AS STATUS /* kata STATUS atau kata setela AS itu bebas tidak berpengaruh pada hasil */
FROM sheet2;


-- pembatas


DROP TABLE warga;

CREATE TABLE warga (
	nama VARCHAR(6),
	jenis_kelamin VARCHAR(6),
	status VARCHAR(7),
	PRIMARY KEY (nama, jenis_kelamin, status)
);

INSERT INTO warga VALUES
	("Amin", "Pria", "Lajang"), 
	("Rahman", "Pria", "Kawin"), 
	("Luki", "Pria", "Cerai"), 
	("Dea", "Wanita", "Lajang"), 
	("Yani", "Wanita", "Kawin"), 
	("Enda", "Wanita", "Cerai"),
	("Dea", "Wanita", "Cerai");

-- CREATE VIEW vw_seluruh_warga AS
	SELECT *
	FROM warga;

SELECT 
		nama,
		jenis_kelamin,
		status,
		IF(jenis_kelamin="Pria",
			IF(Status="Lajang",
				"Perjaka",
				IF(Status="Kawin",
					"Menikah",
					"Duda"
				)
			),
			IF(Status="lajang",
					"Perawan",
				IF(Status="Kawin",
					"Menikah",
					"Janda"
				)
			)
		) AS Keterangan_IF,

		-- membuat if lain untuk kolom keterangan
		CASE jenis_kelamin
			WHEN 'Pria' THEN
				CASE status
					WHEN 'Lajang' THEN 'Perjaka'
					WHEN 'Kawin' THEN 'Menikah'
					ELSE 'Duda'
				END
			ELSE
				CASE status
					WHEN 'Lajang' THEN 'Perawan'
					WHEN 'Kawin' THEN 'Menikah'
					ELSE 'Janda'
				END
			END AS Keterangan_Case
	FROM warga;

-- Pembatas

CREATE TABLE IF NOT EXISTS nilai (
	nama VARCHAR(7),
	teori_nyata TINYINT,
	praktek_nyata TINYINT,
	PRIMARY KEY (nama, teori_nyata, praktek_nyata)
);

-- DROP TABLE nilai  /* drop nilai digunakan jika ingin mengahapus tabel */
DELETE FROM nilai; /* delete from digunakan jika pernah membuat tabel lalu ingin diedit atau ditambahkan */ 

INSERT INTO nilai VALUES
	("Rohmah", 90, 90),
	("Ica", 80, 80),
	("Ryantri", 70, 70),
	("Reka", 50, 50),
	("Irman", 50, 49);

CREATE VIEW IF NOT EXISTS vw_nilai_prosentase_TP AS
	SELECT
			nama,
			teori_nyata,
			teori_nyata*0.3 AS ProsenTeori,
			praktek_nyata,
			praktek_nyata*0.7 AS ProsenPraktek
	   	FROM nilai;

	-- DROP VIEW vw_nilai_prosentase_TP;
		
CREATE VIEW IF NOT EXISTS vw_nilai_siswa_total AS
	SELECT
			nama,
			teori_nyata,
			ProsenTeori,
			praktek_nyata,
			ProsenPraktek,
			ProsenTeori + ProsenPraktek AS Total
	FROM 	vw_nilai_prosentase_TP;

	-- DROP VIEW vw_nilai_siswa_total;

CREATE VIEW IF NOT EXISTS vw_nilai_siswa_grade AS
	SELECT 
			/* bagian sini */
			nama,
			teori_nyata,
			ProsenTeori,
			praktek_nyata,
			ProsenPraktek,
			Total, /* sampai bagian sini merupakan nama kolom yang ada di tabel EXCEL atau MySQL  */

	CASE
		WHEN total >= 90
			THEN "A"
		WHEN total >= 80
			THEN "B"
		WHEN total >= 70
			THEN "C"
		WHEN total >= 60
			THEN "D"
		ELSE "E"
	END AS Grade
	FROM vw_nilai_siswa_total;

	-- DROP VIEW vw_nilai_siswa_grade;

CREATE VIEW IF NOT EXISTS vw_nilai_siswa_kompetensi AS
	SELECT
			Nama,
			Teori_nyata,
			ProsenTeori,
			praktek_nyata,
			ProsenPraktek,
			Total,
			Grade,

	CASE 
		WHEN Grade <= 'B'
			THEN 'K'
		WHEN Grade >= 'C'
			THEN 'BK'
	END AS Kompetensi
	FROM 	vw_nilai_siswa_grade;

	-- DROP VIEW vw_nilai_siswa_kompetensi;

DROP VIEW vw_nilai_siswa_keterangan; /* Jika drop view tidak ingin dimatikan seperti diatas maka hilangkan IF NOT EXISTS dan gunakan DROP VIEW diatas CREATE */
CREATE VIEW vw_nilai_siswa_keterangan AS
	SELECT
			nama,
			teori_nyata,
			ProsenTeori,
			praktek_nyata,
			ProsenPraktek,
			total,
			Grade,
			Kompetensi,

		CASE Grade
			WHEN 'A' THEN 'Memuaskan'
			WHEN 'B' THEN 'Baik'
			WHEN 'C' THEN 'Cukup'
			ELSE 'Tidak Lulus'
		END AS Keterangan
	FROM vw_nilai_siswa_kompetensi;

	-- pembatas

DROP VIEW vw_jumlah_grade;
CREATE VIEW vw_jumlah_grade AS
	SELECT	Grade AS NamaGrade,
			COUNT(Grade) AS JumlahSiswa
	FROM 	vw_nilai_siswa_keterangan
	GROUP BY Grade;

DROP VIEW vw_jumlah_kompetensi;
CREATE VIEW vw_jumlah_kompetensi AS
	SELECT	Kompetensi AS NamaKompetensi,
			COUNT(Kompetensi) AS JumlahSiswa
	FROM 	vw_nilai_siswa_keterangan
	GROUP BY Kompetensi;

DROP VIEW vw_jumlah_keterangan;
CREATE VIEW vw_jumlah_keterangan AS
	SELECT	Keterangan AS NamaKeterangan,
			COUNT(Keterangan) AS JumlahSiswa
	FROM 	vw_nilai_siswa_keterangan
	GROUP BY Keterangan;


-- Pembatas

-- DROP DATABASE asn;
-- CREATE DATABASE asn;

-- -- DROP TABLE asn;
-- CREATE TABLE asn (
-- 	nip VARCHAR(18) PRIMARY KEY,
-- 	nama VARCHAR(5)
-- );

-- INSERT INTO asn VALUES
-- 	('197209172005011002','Irman'),
-- 	('198201312010052001','Ica'),
-- 	('200901202015071004','Angga'),
-- 	('201507142019031002','Reka'),
-- 	('201411142020102003','Irman');

-- -- DROP VIEW vw_tanggal_lahir;
-- CREATE VIEW vw_tanggal AS
-- 	SELECT
-- 			nip,
-- 			nama,
-- 			DATE_FORMAT(LEFT(nip,8),"%W, %D, %M, %Y") AS Lahir,
-- 			DATE_FORMAT(CONCAT(MID(nip,9,6),"01"),"%M, %Y") AS Pengangkatan	
-- 	FROM asn;

-- CREATE VIEW vw_jenis_kelamin AS
-- 	SELECT
-- 			nip,
-- 			nama,
			
















-- SELECT
-- 		nama,
-- 		teori_nyata as nilai_teori_nyata,
-- 		teori_nyata*0.3 as 'Nilai Teori 30%',
-- 		praktek_nyata as nilai_praktek_nyata,
-- 		praktek_nyata*0.7 as 'Nilai Praktek 70%',
-- 		teori_nyata*0.3 + praktek_nyata*0.7 as 'Nilai Total',

-- 		if(teori_nyata*0.3 + praktek_nyata*0.7>90,
-- 			"A",
-- 			if(teori_nyata*0.3 + praktek_nyata*0.7>80,
-- 				"B",
-- 				if(teori_nyata*0.3 + praktek_nyata*0.7>70,
-- 					"C",
-- 					if(teori_nyata*0.3 + praktek_nyata*0.7>60,
-- 						"D",
-- 						"E"
-- 						)
-- 					)
-- 				)
-- 			)
		













-- 			THEN 'A'
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 80
-- 			THEN 'B'
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 70
-- 			THEN 'C'
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 60
-- 			THEN 'D'
-- 		ELSE 'E'
-- 	END AS Grade,

-- 	CASE
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 80
-- 			THEN 'K'
-- 		ELSE 'BK'
-- 	END AS Kompetensi,

-- 	CASE
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 90
-- 			THEN 'Memuaskan'
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 80
-- 			THEN 'Baik'
-- 		WHEN teori_nyata*30/100 + praktek_nyata*70/100 > 70
-- 			THEN 'Cukup'
-- 		WHEN teori_nyata*30/100 + praktek_nyata* 70/100 > 60
-- 			THEN 'Tidak Lulus'
-- 		ELSE 'Tidak Lulus'
-- 	END AS Keterangan

-- FROM nilai;
-- -- ORDER BY teori_nyata DESC;
			













/* Cara lain rumus CASE */

-- 		CASE WHEN jenis_kelamin = "Pria"
-- 			THEN
-- 				CASE WHEN status = "Lajang"
-- 					THEN "Perjaka"
-- 					ELSE
-- 						CASE WHEN status ="Kawin"
-- 							THEN "Menikah"
-- 							ELSE "Duda"
-- 						END
-- 				END
-- 			ELSE
-- 				CASE WHEN status = "Lajang"
-- 					THEN "Perempuan"
-- 					ELSE
-- 						CASE WHEN status ="Kawin"
-- 							THEN "Menikah"
-- 							ELSE "Janda"
-- 						END
-- 				END
-- 			END AS Keterangan_Case
-- FROM warga
-- ORDER BY status ASC;



/* Membuat PRIMARY KEY diluar perintah CREATE TABLE */
-- jangan gunakan if not exist jika di web server sudah terdapat data tersebut
-- CREATE TABLE IF NOT EXISTS warga(
-- 	nama VARCHAR(6),
-- 	jenis_kelamin VARCHAR(6),
-- 	status VARCHAR(7)
-- );

-- ALTER TABLE warga
-- 	DROP PRIMARY KEY;

-- ALTER TABLE warga
-- 	ADD PRIMARY KEY(warga);
-- DELETE FROM Warga;

-- INSERT INTO Warga VALUES ("Amin", "Pria", "Lajang"), ("Rahman", "Pria", "Kawin"), ("Luki", "Pria", "Cerai"), 
-- ("Dea", "Wanita", "Lajang"), ("Yani", "Wanita", "Kawin"), ("Enda", "Wanita", "Cerai");

-- SELECT*,
-- 		IF(jenis_kelamin="Pria",
-- 			IF(Status="Lajang","Perjaka",
-- 			IF(Status="Kawin","Menikah","Duda")),
-- 			IF(Status="lajang","Perawan",
-- 			IF(Status="Kawin","Menikah","Janda"))
-- 		   ) AS Keterangan
-- FROM Warga;
DROP DATABASE fungsi_sp;
CREATE DATABASE fungsi_sp;

USE fungsi_sp;

DELIMITER ;;
-- FUNCTION lebih ke arah untuk pembuatan perhitungan
CREATE FUNCTION sp_kalkulator (
	m_bil_A SMALLINT,
	m_operator VARCHAR(6),
	m_bil_B SMALLINT
)RETURNS SMALLINT DETERMINISTIC /* pada kata RETURNS pada fungsi ini S nya jangan sampai tertinggal */
BEGIN
	RETURN
	CASE m_operator 
		WHEN 'tambah' THEN m_bil_A + m_bil_B
		WHEN 'kurang' THEN m_bil_A - m_bil_B
		WHEN 'kali' THEN m_bil_A * m_bil_B
		ELSE m_bil_A / m_bil_B
	END;
END;;
DELIMITER ;
-- -- CREATE FUNCTION manggil nya pakai SELECT
SELECT sp_kalkulator(10, 'tambah', 5);
SELECT sp_kalkulator(10, 'kurang', 5);
SELECT sp_kalkulator(10, 'kali', 5);
SELECT sp_kalkulator(10, 'bagi', 5);

-- pembatas

DELIMITER ;;
CREATE FUNCTION sp_luastanah (
	m_lebar SMALLINT,
	m_panjang SMALLINT
)RETURNS SMALLINT DETERMINISTIC /* pada kata RETURNS pada fungsi ini S nya jangan sampai tertinggal */
BEGIN
	RETURN
	panjang * lebar
END;;
DELIMITER ;
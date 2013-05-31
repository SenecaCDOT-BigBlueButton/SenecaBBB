/*
  Create primary keys for tables that auto generate primary keys

  - Bo Li
*/
INSERT INTO bbb_admin VALUES (1, 0, 0, 0, 0, 0, 0, 10);

DROP FUNCTION IF EXISTS fn_next_ur_id;
DROP FUNCTION IF EXISTS fn_next_m_id;
DROP FUNCTION IF EXISTS fn_next_ms_id;
DROP FUNCTION IF EXISTS fn_next_l_id;
DROP FUNCTION IF EXISTS fn_next_ls_id;
DROP FUNCTION IF EXISTS fn_next_d_id;

DELIMITER //
CREATE FUNCTION fn_next_ur_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE ur_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_ur_id = next_ur_id + 1
  WHERE row_num = 1;
  SELECT next_ur_id
  INTO ur_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN ur_id_nextval;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_next_m_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE m_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_m_id = next_m_id + 1
  WHERE row_num = 1;
  SELECT next_m_id
  INTO m_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN m_id_nextval;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_next_ms_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE ms_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_ms_id = next_ms_id + 1
  WHERE row_num = 1;
  SELECT next_ms_id
  INTO ms_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN ms_id_nextval;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_next_l_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE l_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_l_id = next_l_id + 1
  WHERE row_num = 1;
  SELECT next_l_id
  INTO l_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN l_id_nextval;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_next_ls_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE ls_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_ls_id = next_ls_id + 1
  WHERE row_num = 1;
  SELECT next_ls_id
  INTO ls_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN ls_id_nextval;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_next_d_id()
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE d_id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET next_d_id = next_d_id + 1
  WHERE row_num = 1;
  SELECT next_d_id
  INTO d_id_nextval
  FROM bbb_admin 
  WHERE row_num = 1;
  RETURN d_id_nextval;
END//
DELIMITER ;

/*
  Create primary keys for tables that auto generate primary keys

  - Bo Li
*/

INSERT INTO bbb_admin VALUES (1, 0, 0, 0, 10, 'Welcome', 'Recording');

DROP FUNCTION IF EXISTS fn_next_ur_id;
DROP FUNCTION IF EXISTS fn_next_ms_id;
DROP FUNCTION IF EXISTS fn_next_ls_id;

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


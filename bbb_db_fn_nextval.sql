/*
  Create primary keys for tables that auto generate primary keys

  - Bo Li
*/

INSERT INTO bbb_admin VALUES ('next_ms_id', 'Next Meeting Schedule Id', '0');
INSERT INTO bbb_admin VALUES ('next_ls_id', 'Next Lecture Schedule Id', '0');
INSERT INTO bbb_admin VALUES ('next_ur_id', 'Next User Role Id', '0');
INSERT INTO bbb_admin VALUES ('timeout', 'Session timeout limit', '10');
INSERT INTO bbb_admin VALUES ('welcome_msg', 'Welcome Message', 'Welcome');
INSERT INTO bbb_admin VALUES ('recording_msg', 'Recording Message', 'Recording');

DROP FUNCTION IF EXISTS fn_next_id;

DELIMITER //
CREATE FUNCTION fn_next_id(param1 VARCHAR(50))
RETURNS MEDIUMINT UNSIGNED
BEGIN
  DECLARE id_nextval MEDIUMINT UNSIGNED;
  UPDATE bbb_admin
  SET key_value = key_value + 1
  WHERE key_name = param1;
  SELECT key_value
  INTO id_nextval
  FROM bbb_admin 
  WHERE key_name = param1;
  RETURN id_nextval;
END//
DELIMITER ;

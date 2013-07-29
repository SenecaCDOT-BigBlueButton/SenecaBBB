/*
  This script must be run alone with the DB Creation script
    -Add initial data
    -Function to generate primary key sequence

  - Bo Li
*/

INSERT INTO bbb_admin VALUES ('next_ms_id', 'Next Meeting Schedule Id', '0');
INSERT INTO bbb_admin VALUES ('next_ls_id', 'Next Lecture Schedule Id', '0');
INSERT INTO bbb_admin VALUES ('next_ur_id', 'Next User Role Id', '0');
INSERT INTO bbb_admin VALUES ('timeout', 'Session timeout limit', '10');
INSERT INTO bbb_admin VALUES ('welcome_msg', 'Welcome Message', 'Welcome');
INSERT INTO bbb_admin VALUES ('recording_msg', 'Recording Message', 'Recording');
INSERT INTO bbb_admin VALUES ('default_meeting', 'Default meeting setting', b'0011001');
INSERT INTO bbb_admin VALUES ('default_user', 'Default user setting', b'001');
INSERT INTO bbb_admin VALUES ('default_class', 'Default class section setting', b'0011110');

DROP FUNCTION IF EXISTS fn_next_id;
DROP PROCEDURE IF EXISTS sp_meeting_schedule;

DELIMITER //
CREATE FUNCTION fn_next_id(param1 VARCHAR(50))
RETURNS INT UNSIGNED
BEGIN
  DECLARE id_nextval INT UNSIGNED;
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

DELIMITER //
CREATE PROCEDURE sp_meeting_schedule(IN title VARCHAR(100),
									 IN inidatetime DATETIME,
								     IN intervals INT UNSIGNED,
									 IN repeats INT UNSIGNED,
									 IN duration INT UNSIGNED,
                                     IN id VARCHAR(100))
BEGIN
  DECLARE nextval INT UNSIGNED;
  DECLARE counter INT DEFAULT 0;
  #DECLARE next_m INT DEFAULT 0;
  SET nextval = fn_next_id('next_ms_id');
  INSERT INTO meeting_schedule VALUES 
	(nextval, title, inidatetime, intervals, repeats, duration, id);
  loop1: LOOP
	SET counter = counter + 1;
    INSERT INTO meeting VALUES 
		(nextval, counter, inidatetime + INTERVAL (counter - 1) * intervals DAY,
			duration, 0, title, 'modpass', 'userpass', 
			(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
	IF counter < repeats THEN ITERATE loop1;
	END IF;
	LEAVE loop1;
  END LOOP loop1;
END//
DELIMITER ;

INSERT INTO predefined_role VALUES ('employee', b'11');
INSERT INTO predefined_role VALUES ('student', b'01');
INSERT INTO predefined_role VALUES ('guest', b'00');

INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'employee', b'11');
INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'student', b'01');
INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'guest', b'00');



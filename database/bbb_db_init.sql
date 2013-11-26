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
INSERT INTO bbb_admin VALUES ('default_meeting_hr', 'Default meeting setting in readable format', 25);
INSERT INTO bbb_admin VALUES ('default_user', 'Default user setting', b'001');
INSERT INTO bbb_admin VALUES ('default_user_hr', 'Default user setting in readable format', 1);
INSERT INTO bbb_admin VALUES ('default_class', 'Default class section setting', b'0011110');
INSERT INTO bbb_admin VALUES ('default_class_hr', 'Default class section setting in readable format', 30);

DROP FUNCTION IF EXISTS fn_next_id;
DROP PROCEDURE IF EXISTS sp_create_ms;
DROP PROCEDURE IF EXISTS sp_edit_ms;
DROP PROCEDURE IF EXISTS sp_create_m_daily1;
DROP PROCEDURE IF EXISTS sp_create_m_daily2;
DROP PROCEDURE IF EXISTS sp_create_m_weekly1;
DROP PROCEDURE IF EXISTS sp_create_m_weekly2;
DROP PROCEDURE IF EXISTS sp_create_m_weekly3;
DROP PROCEDURE IF EXISTS sp_create_m_monthly1;
DROP PROCEDURE IF EXISTS sp_create_m_monthly2;
DROP PROCEDURE IF EXISTS sp_update_m_duration;
#DROP PROCEDURE IF EXISTS sp_update_ms_repeats;
#DROP PROCEDURE IF EXISTS sp_update_ms_inidatetime;
DROP PROCEDURE IF EXISTS sp_update_m_time;
DROP PROCEDURE IF EXISTS sp_create_ls;
DROP PROCEDURE IF EXISTS sp_edit_ls;
DROP PROCEDURE IF EXISTS sp_create_l_once;
DROP PROCEDURE IF EXISTS sp_create_l_daily1;
DROP PROCEDURE IF EXISTS sp_create_l_daily2;
DROP PROCEDURE IF EXISTS sp_create_l_weekly1;
DROP PROCEDURE IF EXISTS sp_create_l_weekly2;
DROP PROCEDURE IF EXISTS sp_create_l_weekly3;
DROP PROCEDURE IF EXISTS sp_create_l_monthly1;
DROP PROCEDURE IF EXISTS sp_create_l_monthly2;
#DROP PROCEDURE IF EXISTS sp_update_ls_inidatetime;
DROP PROCEDURE IF EXISTS sp_update_l_duration;
DROP PROCEDURE IF EXISTS sp_update_l_time;
#DROP PROCEDURE IF EXISTS sp_update_ls_repeats;
DROP PROCEDURE IF EXISTS sp_delete_ls;
DROP PROCEDURE IF EXISTS sp_delete_ms;

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
CREATE PROCEDURE sp_create_ms(
	IN p_ms_title VARCHAR(100),
	IN p_ms_inidatetime DATETIME,
	IN p_ms_spec VARCHAR(100),
	IN p_ms_duration INT UNSIGNED,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _nextval INT UNSIGNED DEFAULT fn_next_id('next_ms_id');
	DECLARE _type1 INT DEFAULT substring(p_ms_spec, 1, 1);
	DECLARE _type2 INT;
	DECLARE _repeat INT;
	DECLARE _interval INT;
	DECLARE _enddate DATE;
	DECLARE _weekbit CHAR(10);
	DECLARE _day INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			CALL sp_delete_ms(_nextval);
			UPDATE bbb_admin
				SET key_value = key_value - 1
				WHERE key_name = 'next_ms_id';
			RESIGNAL;
		END;
	INSERT INTO meeting_schedule VALUES 
		(_nextval, p_ms_title, p_ms_inidatetime, 
		p_ms_spec, p_ms_duration, p_bu_id);
	CASE _type1
		WHEN 1 THEN
			BEGIN
				INSERT INTO meeting VALUES 
					(_nextval, 1, p_ms_inidatetime, p_ms_duration, 
					0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
					(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id)); 
			END;
		WHEN 2 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				IF _type2 = 1 THEN
					SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
						INTO _repeat;
					SELECT substring_index(p_ms_spec, ';', -1)
						INTO _interval;
					CALL sp_create_m_daily1(0, _repeat, _interval, _nextval, p_ms_inidatetime, p_ms_duration,
						p_m_description, p_bu_id);
				ELSE
					SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
						INTO _enddate;
					SELECT substring_index(p_ms_spec, ';', -1)
						INTO _interval;
					CALL sp_create_m_daily2(0, _enddate, _interval, _nextval, p_ms_inidatetime, p_ms_duration,
						p_m_description, p_bu_id);
				END IF;
			END;
		WHEN 3 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly1(0, _repeat, _interval, _weekbit, _nextval, p_ms_inidatetime, 
								p_ms_duration, p_m_description, p_bu_id);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly2(0, _repeat, _interval, _weekbit, _nextval, p_ms_inidatetime, 
								p_ms_duration, p_m_description, p_bu_id);
						END;
					WHEN 3 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _enddate;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly3(0, _enddate, _interval, _weekbit, _nextval, p_ms_inidatetime, 
								p_ms_duration, p_m_description, p_bu_id);
						END;
				END CASE;
			END;
		WHEN 4 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _day;
							CALL sp_create_m_monthly1(0, _repeat, _interval, _day, _nextval, p_ms_inidatetime, 
								p_ms_duration, p_m_description, p_bu_id);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _day;
							CALL sp_create_m_monthly2(0, _repeat, _interval, _day, _nextval, p_ms_inidatetime, 
								p_ms_duration, p_m_description, p_bu_id);
						END;
				END CASE;
			END;
	END CASE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_edit_ms(
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_spec VARCHAR(100),
	IN p_m_description VARCHAR(2000))
BEGIN
	DECLARE _bu_id VARCHAR(100);
	DECLARE _duration INT UNSIGNED;
	DECLARE _count INT UNSIGNED;
	DECLARE _type1 INT DEFAULT substring(p_ms_spec, 1, 1);
	DECLARE _type2 INT;
	DECLARE _repeat INT;
	DECLARE _interval INT;
	DECLARE _enddate DATE;
	DECLARE _weekbit CHAR(10);
	DECLARE _day INT;
	SELECT bu_id, ms_duration
		INTO _bu_id, _duration
		FROM meeting_schedule
		WHERE ms_id = p_ms_id;
	DELETE FROM meeting 
		WHERE ms_id = p_ms_id 
		AND m_inidatetime > sysdate();
	SELECT count(*) INTO _count
		FROM meeting
		WHERE ms_id = p_ms_id;
	IF _count != 0 THEN
		SELECT max(m_id) INTO _count
			FROM meeting
			WHERE ms_id = p_ms_id;
	END IF;
	UPDATE meeting_schedule
		SET ms_spec = p_ms_spec
		WHERE ms_id = p_ms_id;
	IF _count = 0 THEN
		UPDATE meeting_schedule
			SET ms_inidatetime = p_ms_inidatetime
			WHERE ms_id = p_ms_id;
	END IF;
	CASE _type1
		WHEN 1 THEN
			BEGIN
				INSERT INTO meeting VALUES 
					(p_ms_id, _count + 1, p_ms_inidatetime, _duration, 
					0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
					(SELECT m_setting FROM bbb_user WHERE bu_id = _bu_id)); 
			END;
		WHEN 2 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				IF _type2 = 1 THEN
					SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
						INTO _repeat;
					SELECT substring_index(p_ms_spec, ';', -1)
						INTO _interval;
					CALL sp_create_m_daily1(_count, _repeat, _interval, p_ms_id, p_ms_inidatetime, _duration,
						p_m_description, _bu_id);
				ELSE
					SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
						INTO _enddate;
					SELECT substring_index(p_ms_spec, ';', -1)
						INTO _interval;
					CALL sp_create_m_daily2(_count, _enddate, _interval, p_ms_id, p_ms_inidatetime, _duration,
						p_m_description, _bu_id);
				END IF;
			END;
		WHEN 3 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly1(_count, _repeat, _interval, _weekbit, p_ms_id, p_ms_inidatetime, 
								_duration, p_m_description, _bu_id);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly2(_count, _repeat, _interval, _weekbit, p_ms_id, p_ms_inidatetime, 
								_duration, p_m_description, _bu_id);
						END;
					WHEN 3 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _enddate;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_m_weekly3(_count, _enddate, _interval, _weekbit, p_ms_id, p_ms_inidatetime, 
								_duration, p_m_description, _bu_id);
						END;
				END CASE;
			END;
		WHEN 4 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ms_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _day;
							CALL sp_create_m_monthly1(_count, _repeat, _interval, _day, p_ms_id, p_ms_inidatetime, 
								_duration, p_m_description, _bu_id);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ms_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ms_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ms_spec, ';', -1)
								INTO _day;
							CALL sp_create_m_monthly2(_count, _repeat, _interval, _day, p_ms_id, p_ms_inidatetime, 
								_duration, p_m_description, _bu_id);
						END;
				END CASE;
			END;
	END CASE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_m_daily1(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO meeting VALUES 
			(p_ms_id, _counter, p_ms_inidatetime + INTERVAL (_counter - 1) * p_interval DAY,
			p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
			(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_m_daily2(
	IN p_count INT,
	IN p_enddate DATE,
	IN p_interval INT,
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _current DATETIME DEFAULT p_ms_inidatetime;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO meeting VALUES 
			(p_ms_id, _counter, _current,
			p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
			(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
		SET _current = _current + INTERVAL p_interval DAY;
		IF DATE(_current) <= p_enddate THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on a total number of sessions
DELIMITER //
CREATE PROCEDURE sp_create_m_weekly1(
	IN p_count INT,
	IN p_repeat INT,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _current DATETIME DEFAULT p_ms_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO meeting VALUES 
				(p_ms_id, _counter, _current,
				p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
				(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
			SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF _counter <= (p_repeat + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on a total number of weeks
DELIMITER //
CREATE PROCEDURE sp_create_m_weekly2(
	IN p_count INT,
	IN p_repeat INT,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _w_counter INT DEFAULT 1;
	DECLARE _current DATETIME DEFAULT p_ms_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO meeting VALUES 
				(p_ms_id, _counter, _current,
				p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
				(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
			SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
			SET _w_counter = _w_counter + 1;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF _w_counter <= p_repeat THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on an end date
DELIMITER //
CREATE PROCEDURE sp_create_m_weekly3(
	IN p_count INT,
	IN p_enddate DATE,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _current DATETIME DEFAULT p_ms_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO meeting VALUES 
				(p_ms_id, _counter, _current,
				p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
				(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
				SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF date(_current) <= p_enddate THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# create events on specfic day of month, auto change date to last day of month if
# selected date is out of bound in another month
DELIMITER //
CREATE PROCEDURE sp_create_m_monthly1(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_day INT,
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _current DATETIME;
	DECLARE _diff INT DEFAULT DAY(p_ms_inidatetime) - p_day; 
	DECLARE _offset INT;
	IF _diff > 0 THEN
		IF DAY(LAST_DAY(p_ms_inidatetime + INTERVAL 1 MONTH)) >= p_day THEN
			SET _current = concat(YEAR(p_ms_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ms_inidatetime + INTERVAL 1 MONTH), '-',
				p_day, ' ', TIME(p_ms_inidatetime));
		ELSE
			SET _current = concat(YEAR(p_ms_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ms_inidatetime + INTERVAL 1 MONTH), '-',
				DAY(LAST_DAY(p_ms_inidatetime + INTERVAL 1 MONTH)), ' ', 
				TIME(p_ms_inidatetime));
		END IF;
	ELSE
		IF DAY(LAST_DAY(p_ms_inidatetime)) >= p_day THEN
			SET _current = concat(YEAR(p_ms_inidatetime), '-', 
				MONTH(p_ms_inidatetime), '-',
				p_day, ' ', TIME(p_ms_inidatetime));
		ELSE
			SET _current = concat(YEAR(p_ms_inidatetime), '-', 
				MONTH(p_ms_inidatetime), '-',
				DAY(LAST_DAY(p_ms_inidatetime)), ' ', 
				TIME(p_ms_inidatetime));
		END IF;
	END IF;
	loop1: LOOP
		SET _counter = _counter + 1;
		SET _offset = p_day - DAY(_current);
		INSERT INTO meeting VALUES 
			(p_ms_id, _counter, _current,
			p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
			(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
		IF DAY(LAST_DAY(_current + INTERVAL p_interval MONTH)) >= p_day THEN
			SET _current = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				p_day, ' ', TIME(_current));
		ELSE
			SET _current = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				DAY(LAST_DAY(_current + INTERVAL p_interval MONTH)), ' ', TIME(_current));
		END IF;
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# create events on first occurance of a day of week(S,M,T,W,T,F,S)
# Sunday = 1 ... Saturday = 7
DELIMITER //
CREATE PROCEDURE sp_create_m_monthly2(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_day INT UNSIGNED,
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME,
	IN p_ms_duration INT,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _flag INT DEFAULT 0;
	DECLARE _current DATETIME;
	DECLARE _loop DATETIME;
	IF DAY(p_ms_inidatetime) <= 7 THEN
		SET _loop = p_ms_inidatetime;
		loop2: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop2;
			END IF;
			LEAVE loop2;
		END LOOP loop2;
	END IF;
	IF _flag = 0 THEN
		SET _loop = concat(YEAR(p_ms_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ms_inidatetime + INTERVAL 1 MONTH), '-',
				1, ' ', TIME(p_ms_inidatetime));
		loop3: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop3;
			END IF;
			LEAVE loop3;
		END LOOP loop3;
	END IF;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO meeting VALUES 
			(p_ms_id, _counter, _current,
			p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
			(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
		
		SET _flag = 0;
		SET _loop = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				1, ' ', TIME(_current));
		loop4: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop4;
			END IF;
			LEAVE loop4;
		END LOOP loop4;
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_ls(
	IN p_c_id CHAR(8),
	IN p_sc_id CHAR(2),
	IN p_sc_semesterid INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_spec VARCHAR(100),
	IN p_ls_duration INT UNSIGNED,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _nextval INT UNSIGNED DEFAULT fn_next_id('next_ls_id');
	DECLARE _type1 INT DEFAULT substring(p_ls_spec, 1, 1);
	DECLARE _type2 INT;
	DECLARE _repeat INT;
	DECLARE _interval INT;
	DECLARE _enddate DATE;
	DECLARE _weekbit CHAR(10);
	DECLARE _day INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			CALL sp_delete_ls(_nextval);
			UPDATE bbb_admin
				SET key_value = key_value - 1
				WHERE key_name = 'next_ls_id';
			RESIGNAL;
		END;
	INSERT INTO lecture_schedule VALUES 
		(_nextval, p_c_id, p_sc_id, p_sc_semesterid, p_ls_inidatetime, 
		p_ls_spec, p_ls_duration);
	CASE _type1
		WHEN 1 THEN
			BEGIN
				INSERT INTO lecture VALUES 
					(_nextval, 1, p_ls_inidatetime, p_ls_duration, 
					0, p_l_description, floor(rand() * 10000), floor(rand() * 10000)); 
			END;
		WHEN 2 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				IF _type2 = 1 THEN
					SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
						INTO _repeat;
					SELECT substring_index(p_ls_spec, ';', -1)
						INTO _interval;
					CALL sp_create_l_daily1(0, _repeat, _interval, _nextval, p_ls_inidatetime, p_ls_duration,
						p_l_description);
				ELSE
					SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
						INTO _enddate;
					SELECT substring_index(p_ls_spec, ';', -1)
						INTO _interval;
					CALL sp_create_l_daily2(0, _enddate, _interval, _nextval, p_ls_inidatetime, p_ls_duration,
						p_l_description);
				END IF;
			END;
		WHEN 3 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly1(0, _repeat, _interval, _weekbit, _nextval, p_ls_inidatetime, 
								p_ls_duration, p_l_description);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly2(0, _repeat, _interval, _weekbit, _nextval, p_ls_inidatetime, 
								p_ls_duration, p_l_description);
						END;
					WHEN 3 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _enddate;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly3(0, _enddate, _interval, _weekbit, _nextval, p_ls_inidatetime, 
								p_ls_duration, p_l_description);
						END;
				END CASE;
			END;
		WHEN 4 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _day;
							CALL sp_create_l_monthly1(0, _repeat, _interval, _day, _nextval, p_ls_inidatetime, 
								p_ls_duration, p_l_description);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _day;
							CALL sp_create_l_monthly2(0, _repeat, _interval, _day, _nextval, p_ls_inidatetime, 
								p_ls_duration, p_l_description);
						END;
				END CASE;
			END;
	END CASE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_edit_ls(
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_spec VARCHAR(100),
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _duration INT UNSIGNED;
	DECLARE _count INT UNSIGNED;
	DECLARE _type1 INT DEFAULT substring(p_ls_spec, 1, 1);
	DECLARE _type2 INT;
	DECLARE _repeat INT;
	DECLARE _interval INT;
	DECLARE _enddate DATE;
	DECLARE _weekbit CHAR(10);
	DECLARE _day INT;
	SELECT ls_duration
		INTO _duration
		FROM lecture_schedule
		WHERE ls_id = p_ls_id;
	DELETE FROM lecture 
		WHERE ls_id = p_ls_id 
		AND l_inidatetime > sysdate();
	SELECT count(*) INTO _count
		FROM lecture
		WHERE ls_id = p_ls_id;
	IF _count != 0 THEN
		SELECT max(l_id) INTO _count
			FROM lecture
			WHERE ls_id = p_ls_id;
	END IF;
	UPDATE lecture_schedule
		SET ls_spec = p_ls_spec
		WHERE ls_id = p_ls_id;
	IF _count = 0 THEN
		UPDATE lecture_schedule
			SET ls_inidatetime = p_ls_inidatetime
			WHERE ls_id = p_ls_id;
	END IF;
	CASE _type1
		WHEN 1 THEN
			BEGIN
				INSERT INTO lecture VALUES 
					(p_ls_id, _count + 1, p_ls_inidatetime, _duration, 
					0, p_l_description, floor(rand() * 10000), floor(rand() * 10000)); 
			END;
		WHEN 2 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				IF _type2 = 1 THEN
					SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
						INTO _repeat;
					SELECT substring_index(p_ls_spec, ';', -1)
						INTO _interval;
					CALL sp_create_l_daily1(_count, _repeat, _interval, p_ls_id, p_ls_inidatetime, _duration,
						p_l_description);
				ELSE
					SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
						INTO _enddate;
					SELECT substring_index(p_ls_spec, ';', -1)
						INTO _interval;
					CALL sp_create_l_daily2(_count, _enddate, _interval, p_ls_id, p_ls_inidatetime, _duration,
						p_l_description);
				END IF;
			END;
		WHEN 3 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly1(_count, _repeat, _interval, _weekbit, p_ls_id, p_ls_inidatetime, 
								_duration, p_l_description);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly2(_count, _repeat, _interval, _weekbit, p_ls_id, p_ls_inidatetime, 
								_duration, p_l_description);
						END;
					WHEN 3 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _enddate;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _weekbit;
							CALL sp_create_l_weekly3(_count, _enddate, _interval, _weekbit, p_ls_id, p_ls_inidatetime, 
								_duration, p_l_description);
						END;
				END CASE;
			END;
		WHEN 4 THEN
			BEGIN
				SELECT substring_index(substring_index(p_ls_spec, ';', 2), ';', -1)
					INTO _type2;
				CASE _type2
					WHEN 1 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _day;
							CALL sp_create_l_monthly1(_count, _repeat, _interval, _day, p_ls_id, p_ls_inidatetime, 
								_duration, p_l_description);
						END;
					WHEN 2 THEN
						BEGIN
							SELECT substring_index(substring_index(p_ls_spec, ';', 3), ';', -1)
								INTO _repeat;
							SELECT substring_index(substring_index(p_ls_spec, ';', 4), ';', -1)
								INTO _interval;
							SELECT substring_index(p_ls_spec, ';', -1)
								INTO _day;
							CALL sp_create_l_monthly2(_count, _repeat, _interval, _day, p_ls_id, p_ls_inidatetime, 
								_duration, p_l_description);
						END;
				END CASE;
			END;
	END CASE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_l_daily1(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO lecture VALUES 
			(p_ls_id, _counter, p_ls_inidatetime + INTERVAL (_counter - 1) * p_interval DAY,
			p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_l_daily2(
	IN p_count INT,
	IN p_enddate DATE,
	IN p_interval INT,
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _current DATETIME DEFAULT p_ls_inidatetime;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO lecture VALUES 
			(p_ls_id, _counter, _current,
			p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
		SET _current = _current + INTERVAL p_interval DAY;
		IF DATE(_current) <= p_enddate THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on a total number of sessions
DELIMITER //
CREATE PROCEDURE sp_create_l_weekly1(
	IN p_count INT,
	IN p_repeat INT,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _current DATETIME DEFAULT p_ls_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO lecture VALUES 
				(p_ls_id, _counter, _current,
				p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
			SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF _counter <= p_repeat THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on a total number of weeks
DELIMITER //
CREATE PROCEDURE sp_create_l_weekly2(
	IN p_count INT,
	IN p_repeat INT,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _w_counter INT DEFAULT 1;
	DECLARE _current DATETIME DEFAULT p_ls_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO lecture VALUES 
				(p_ls_id, _counter, _current,
				p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
			SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
			SET _w_counter = _w_counter + 1;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF _w_counter <= p_repeat THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# this method create events based on an end date
DELIMITER //
CREATE PROCEDURE sp_create_l_weekly3(
	IN p_count INT,
	IN p_enddate DATE,
	IN p_interval INT,
	IN p_weekbit CHAR(10),
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count + 1;
	DECLARE _current DATETIME DEFAULT p_ls_inidatetime;
	loop1: LOOP
		IF substring(p_weekbit, dayofweek(_current), 1) = '1' THEN
			INSERT INTO lecture VALUES 
				(p_ls_id, _counter, _current,
				p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
				SET _counter = _counter + 1;
		END IF;
		IF dayofweek(_current) = 7 && _counter != 1 THEN
			SET _current = _current + INTERVAL (p_interval - 1) * 7 + 1 DAY;
		ELSE 
			SET _current = _current + INTERVAL 1 DAY;
		END IF;
		IF date(_current) <= p_enddate THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# create events on specfic day of month, auto change date to last day of month if
# selected date is out of bound in another month
DELIMITER //
CREATE PROCEDURE sp_create_l_monthly1(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_day INT,
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _current DATETIME;
	DECLARE _diff INT DEFAULT DAY(p_ls_inidatetime) - p_day; 
	DECLARE _offset INT;
	IF _diff > 0 THEN
		IF DAY(LAST_DAY(p_ls_inidatetime + INTERVAL 1 MONTH)) >= p_day THEN
			SET _current = concat(YEAR(p_ls_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ls_inidatetime + INTERVAL 1 MONTH), '-',
				p_day, ' ', TIME(p_ls_inidatetime));
		ELSE
			SET _current = concat(YEAR(p_ls_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ls_inidatetime + INTERVAL 1 MONTH), '-',
				DAY(LAST_DAY(p_ls_inidatetime + INTERVAL 1 MONTH)), ' ', 
				TIME(p_ls_inidatetime));
		END IF;
	ELSE
		IF DAY(LAST_DAY(p_ls_inidatetime)) >= p_day THEN
			SET _current = concat(YEAR(p_ls_inidatetime), '-', 
				MONTH(p_ls_inidatetime), '-',
				p_day, ' ', TIME(p_ls_inidatetime));
		ELSE
			SET _current = concat(YEAR(p_ls_inidatetime), '-', 
				MONTH(p_ls_inidatetime), '-',
				DAY(LAST_DAY(p_ls_inidatetime)), ' ', 
				TIME(p_ls_inidatetime));
		END IF;
	END IF;
	loop1: LOOP
		SET _counter = _counter + 1;
		SET _offset = p_day - DAY(_current);
		INSERT INTO lecture VALUES 
			(p_ls_id, _counter, _current,
			p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
		IF DAY(LAST_DAY(_current + INTERVAL p_interval MONTH)) >= p_day THEN
			SET _current = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				p_day, ' ', TIME(_current));
		ELSE
			SET _current = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				DAY(LAST_DAY(_current + INTERVAL p_interval MONTH)), ' ', TIME(_current));
		END IF;
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;

# create events on first occurance of a day of week(S,M,T,W,T,F,S)
# Sunday = 1 ... Saturday = 7
DELIMITER //
CREATE PROCEDURE sp_create_l_monthly2(
	IN p_count INT,
	IN p_repeats INT,
	IN p_interval INT,
	IN p_day INT,
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_duration INT,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _counter INT DEFAULT p_count;
	DECLARE _flag INT DEFAULT 0;
	DECLARE _current DATETIME;
	DECLARE _loop DATETIME;
	IF DAY(p_ls_inidatetime) <= 7 THEN
		SET _loop = p_ls_inidatetime;
		loop2: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop2;
			END IF;
			LEAVE loop2;
		END LOOP loop2;
	END IF;
	IF _flag = 0 THEN
		SET _loop = concat(YEAR(p_ls_inidatetime + INTERVAL 1 MONTH), '-', 
				MONTH(p_ls_inidatetime + INTERVAL 1 MONTH), '-',
				1, ' ', TIME(p_ls_inidatetime));
		loop3: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop3;
			END IF;
			LEAVE loop3;
		END LOOP loop3;
	END IF;
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO lecture VALUES 
			(p_ls_id, _counter, _current,
			p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
		SET _flag = 0;
		SET _loop = concat(YEAR(_current + INTERVAL p_interval MONTH), '-', 
				MONTH(_current + INTERVAL p_interval MONTH), '-',
				1, ' ', TIME(_current));
		loop4: LOOP
			IF dayofweek(_loop) = p_day THEN
				SET _current = _loop;
				SET _flag = 1;
			END IF;
			SET _loop = _loop + INTERVAL 1 DAY;
			IF DAY(_loop) <= 7 && _flag = 0 THEN ITERATE loop4;
			END IF;
			LEAVE loop4;
		END LOOP loop4;
		IF _counter < (p_repeats + p_count) THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;
	
/*
DELIMITER //
CREATE PROCEDURE sp_create_ms(
	IN p_ms_title VARCHAR(100),
	IN p_ms_inidatetime DATETIME,
	IN p_ms_intervals INT UNSIGNED,
	IN p_ms_repeats INT UNSIGNED,
	IN p_ms_duration INT UNSIGNED,
	IN p_m_description VARCHAR(2000),
	IN p_bu_id VARCHAR(100))
BEGIN
	DECLARE _nextval INT UNSIGNED DEFAULT fn_next_id('next_ms_id');
	DECLARE _counter INT DEFAULT 0;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			DELETE 
				FROM meeting_schedule 
				WHERE ms_id = _nextval;
			UPDATE bbb_admin
				SET key_value = key_value - 1
				WHERE key_name = 'next_ms_id';
			SIGNAL SQLSTATE VALUE '99999'
				SET MESSAGE_TEXT = 'An ERROR occurred while creating meeting schedule';
		END;
	INSERT INTO meeting_schedule VALUES 
		(_nextval, p_ms_title, p_ms_inidatetime, 
		p_ms_intervals, p_ms_repeats, p_ms_duration, p_bu_id);
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO meeting VALUES 
			(_nextval, _counter, p_ms_inidatetime + INTERVAL (_counter - 1) * p_ms_intervals DAY,
			p_ms_duration, 0, p_m_description, floor(rand() * 10000), floor(rand() * 10000), 
			(SELECT m_setting FROM bbb_user WHERE bu_id = p_bu_id));
		IF _counter < p_ms_repeats THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;
*/

/*
	p_num:
	(1) change the current meeting only
	(2) change all sessions after and including the current one
	(3) change all sessions not yet passed (reference to sysdate())
*/
DELIMITER //
CREATE PROCEDURE sp_update_m_duration(
	IN p_num TINYINT UNSIGNED,
	IN p_ms_id INT UNSIGNED,
	IN p_m_id INT UNSIGNED,
	IN p_m_duration INT UNSIGNED)
BEGIN
	CASE p_num
		WHEN 1 THEN
			BEGIN
				UPDATE meeting
					SET m_duration = p_m_duration
					WHERE ms_id = p_ms_id
					AND m_id = p_m_id
					AND m_inidatetime >= sysdate();
			END;
		WHEN 2 THEN
			BEGIN
				DECLARE _inidatetime DATETIME DEFAULT
					(SELECT m_inidatetime 
						FROM meeting 
						WHERE ms_id = p_ms_id
						AND m_id = p_m_id);
				UPDATE meeting_schedule
					SET ms_duration = p_m_duration
					WHERE ms_id = p_ms_id;
				UPDATE meeting
					SET m_duration = p_m_duration
						WHERE ms_id = p_ms_id
						AND m_inidatetime >= _inidatetime
						AND m_inidatetime >= sysdate();
			END;
		WHEN 3 THEN
			BEGIN
				UPDATE meeting_schedule
					SET ms_duration = p_m_duration
					WHERE ms_id = p_ms_id;
				UPDATE meeting
					SET m_duration = p_m_duration
					WHERE ms_id = p_ms_id
					AND m_inidatetime >= sysdate();
			END;
	END CASE;
END//
DELIMITER ;

/*
DELIMITER //
CREATE PROCEDURE sp_update_ms_repeats(
	IN p_ms_id INT UNSIGNED,
	IN p_ms_repeats INT UNSIGNED)
BEGIN
	DECLARE _counter INT DEFAULT 0;
	DECLARE _inidatetime DATETIME;
	DECLARE _repeats INT UNSIGNED;
	DECLARE _duration INT UNSIGNED;
	DECLARE _intervals INT UNSIGNED;
	SELECT ms_inidatetime, ms_repeats, ms_duration, ms_intervals
		INTO _inidatetime, _repeats, _duration, _intervals
		FROM meeting_schedule
		WHERE ms_id = p_ms_id;
	IF p_ms_repeats > _repeats THEN
		SET _counter = _repeats;
		loop1: LOOP
			SET _counter = _counter + 1;
			INSERT INTO meeting VALUES 
				(p_ms_id, _counter, _inidatetime + INTERVAL (_counter - 1) * _intervals DAY,
				_duration, 0, '', floor(rand() * 10000), floor(rand() * 10000), 
				(SELECT m_setting 
					FROM bbb_user, meeting_schedule 
					WHERE bbb_user.bu_id = meeting_schedule.bu_id
					AND meeting_schedule.ms_id = p_ms_id));
			IF _counter < p_ms_repeats THEN ITERATE loop1;
			END IF;
			LEAVE loop1;
		END LOOP loop1;
		UPDATE meeting_schedule
		SET ms_repeats = p_ms_repeats
		WHERE ms_id = p_ms_id;
	ELSEIF p_ms_repeats < _repeats && p_ms_repeats >= 1 THEN
		SET _counter = _repeats - p_ms_repeats; 
		DELETE 
			FROM meeting 
			WHERE ms_id = p_ms_id 
			AND m_inidatetime > sysdate()
			ORDER BY m_inidatetime DESC
			LIMIT _counter;
		UPDATE meeting_schedule
			SET ms_repeats =
				(SELECT count(*)
					FROM meeting
					WHERE ms_id = p_ms_id)
			WHERE ms_id = p_ms_id;
	END IF;  
END//
DELIMITER ;
*/

/*
  p_ms_inidatetime must be in format
  'YYYY-MM-DD HH:MM:SS'

DELIMITER //
CREATE PROCEDURE sp_update_ms_inidatetime(
	IN p_ms_id INT UNSIGNED,
	IN p_ms_inidatetime DATETIME)
BEGIN
	DECLARE _counter INT DEFAULT 0;
	DECLARE _limit INT DEFAULT
		(SELECT count(*)
			FROM meeting
			WHERE ms_id = p_ms_id);
	DECLARE _intervals INT UNSIGNED DEFAULT
		(SELECT ms_intervals
			FROM meeting_schedule
			WHERE ms_id = p_ms_id); 	
	loop1: LOOP
		SET _counter = _counter + 1;
		UPDATE meeting
			SET m_inidatetime = 
				p_ms_inidatetime + INTERVAL (_counter - 1) * _intervals DAY
			WHERE ms_id = p_ms_id
			AND m_id = _counter;
		IF _counter < _limit THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
	UPDATE meeting_schedule
		SET ms_inidatetime = p_ms_inidatetime
		WHERE ms_id = p_ms_id;
END//
DELIMITER ;
*/

/*
	p_num:
	(1) change the current meeting only
	(2) change all sessions after and including the current one
	(3) change all sessions not yet passed (reference to sysdate())
	p_time must be in format HH:MM:SS
*/
DELIMITER //
CREATE PROCEDURE sp_update_m_time(
	IN p_num TINYINT UNSIGNED,
	IN p_ms_id INT UNSIGNED,
	IN p_m_id INT UNSIGNED,
	IN p_time TIME)
BEGIN
	#DECLARE _date DATETIME;
	CASE p_num
		WHEN 1 THEN
			BEGIN
				UPDATE meeting
					SET m_inidatetime = concat(DATE(m_inidatetime), ' ', TIME(p_time))
					WHERE ms_id = p_ms_id
					AND m_id = p_m_id
					AND m_inidatetime >= sysdate();
			END;
		WHEN 2 THEN
			BEGIN
				DECLARE _inidatetime DATETIME DEFAULT
					(SELECT m_inidatetime 
						FROM meeting 
						WHERE ms_id = p_ms_id
						AND m_id = p_m_id);
				UPDATE meeting
					SET m_inidatetime = concat(DATE(m_inidatetime), ' ', TIME(p_time))
						WHERE ms_id = p_ms_id
						AND m_inidatetime >= _inidatetime
						AND m_inidatetime >= sysdate();
				UPDATE meeting_schedule
					SET ms_inidatetime = concat(DATE(ms_inidatetime), ' ', TIME(p_time))
					WHERE ms_id = p_ms_id;
			END;
		WHEN 3 THEN
			BEGIN				
				UPDATE meeting
					SET m_inidatetime = concat(DATE(m_inidatetime), ' ', TIME(p_time))
					WHERE ms_id = p_ms_id
					AND m_inidatetime >= sysdate();
				UPDATE meeting_schedule
					SET ms_inidatetime = concat(DATE(ms_inidatetime), ' ', TIME(p_time))
					WHERE ms_id = p_ms_id;
			END;
	END CASE;
END//
DELIMITER ;

/*
DELIMITER //
CREATE PROCEDURE sp_create_ls(
	IN p_c_id CHAR(8),
	IN p_sc_id CHAR(2),
	IN p_sc_semesterid INT UNSIGNED,
	IN p_ls_inidatetime DATETIME,
	IN p_ls_intervals INT UNSIGNED,
	IN p_ls_repeats INT UNSIGNED,
	IN p_ls_duration INT UNSIGNED,
	IN p_l_description VARCHAR(2000))
BEGIN
	DECLARE _nextval INT UNSIGNED DEFAULT fn_next_id('next_ls_id');
	DECLARE _counter INT DEFAULT 0;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			DELETE 
				FROM lecture_schedule 
				WHERE ls_id = _nextval;
			UPDATE bbb_admin
				SET key_value = key_value - 1
				WHERE key_name = 'next_ls_id';
			SIGNAL SQLSTATE VALUE '99999'
				SET MESSAGE_TEXT = 'An ERROR occurred while creating lecture schedule';
		END;
	INSERT INTO lecture_schedule VALUES 
		(_nextval, p_c_id, p_sc_id, p_sc_semesterid, p_ls_inidatetime, 
		p_ls_intervals, p_ls_repeats, p_ls_duration);
	loop1: LOOP
		SET _counter = _counter + 1;
		INSERT INTO lecture VALUES 
			(_nextval, _counter, p_ls_inidatetime + INTERVAL (_counter - 1) * p_ls_intervals DAY,
			p_ls_duration, 0, p_l_description, floor(rand() * 10000), floor(rand() * 10000));
		IF _counter < p_ls_repeats THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
END//
DELIMITER ;
*/

/*
  p_ms_inidatetime must be in format
  'YYYY-MM-DD HH:MM:SS'

DELIMITER //
CREATE PROCEDURE sp_update_ls_inidatetime(
	IN p_ls_id INT UNSIGNED,
	IN p_ls_inidatetime DATETIME)
BEGIN
	DECLARE _counter INT DEFAULT 0;
	DECLARE _limit INT DEFAULT
		(SELECT count(*)
			FROM lecture
			WHERE ls_id = p_ls_id);
	DECLARE _intervals INT UNSIGNED DEFAULT
		(SELECT ls_intervals
			FROM lecture_schedule
			WHERE ls_id = p_ls_id); 	
	loop1: LOOP
		SET _counter = _counter + 1;
		UPDATE lecture
			SET l_inidatetime = 
				p_ls_inidatetime + INTERVAL (_counter - 1) * _intervals DAY
			WHERE ls_id = p_ls_id
			AND l_id = _counter;
		IF _counter < _limit THEN ITERATE loop1;
		END IF;
		LEAVE loop1;
	END LOOP loop1;
	UPDATE lecture_schedule
		SET ls_inidatetime = p_ls_inidatetime
		WHERE ls_id = p_ls_id;
END//
DELIMITER ;
*/

/*
	p_num:
	(1) change the current lecture only
	(2) change all sessions after and including the current one
	(3) change all sessions not yet passed (reference to sysdate())
*/
DELIMITER //
CREATE PROCEDURE sp_update_l_duration(
	IN p_num TINYINT UNSIGNED,
	IN p_ls_id INT UNSIGNED,
	IN p_l_id INT UNSIGNED,
	IN p_l_duration INT UNSIGNED)
BEGIN
	CASE p_num
		WHEN 1 THEN
			BEGIN
				UPDATE lecture
					SET l_duration = p_l_duration
					WHERE ls_id = p_ls_id
					AND l_id = p_l_id
					AND l_inidatetime >= sysdate();
			END;
		WHEN 2 THEN
			BEGIN
				DECLARE _inidatetime DATETIME DEFAULT
					(SELECT l_inidatetime 
						FROM lecture 
						WHERE ls_id = p_ls_id
						AND l_id = p_l_id);
				UPDATE lecture_schedule
					SET ls_duration = p_l_duration
					WHERE ls_id = p_ls_id;
				UPDATE lecture
					SET l_duration = p_l_duration
						WHERE ls_id = p_ls_id
						AND l_inidatetime >= _inidatetime
						AND l_inidatetime >= sysdate();
			END;
		WHEN 3 THEN
			BEGIN
				UPDATE lecture_schedule
					SET ls_duration = p_l_duration
					WHERE ls_id = p_ls_id;
				UPDATE lecture
					SET l_duration = p_l_duration
					WHERE ls_id = p_ls_id
					AND l_inidatetime >= sysdate();
			END;
	END CASE;
END//
DELIMITER ;

/*
	p_num:
	(1) change the current lecture only
	(2) change all sessions after and including the current one
	(3) change all sessions not yet passed (reference to sysdate())
	p_time must be in format HH:MM:SS
*/
DELIMITER //
CREATE PROCEDURE sp_update_l_time(
	IN p_num TINYINT UNSIGNED,
	IN p_ls_id INT UNSIGNED,
	IN p_l_id INT UNSIGNED,
	IN p_time TIME)
BEGIN
	#DECLARE _date DATETIME;
	CASE p_num
		WHEN 1 THEN
			BEGIN
				UPDATE lecture
					SET l_inidatetime = concat(DATE(l_inidatetime), ' ', TIME(p_time))
					WHERE ls_id = p_ls_id
					AND l_id = p_l_id
					AND l_inidatetime >= sysdate();
			END;
		WHEN 2 THEN
			BEGIN
				DECLARE _inidatetime DATETIME DEFAULT
					(SELECT l_inidatetime 
						FROM lecture 
						WHERE ls_id = p_ls_id
						AND l_id = p_l_id);
				UPDATE lecture
					SET l_inidatetime = concat(DATE(l_inidatetime), ' ', TIME(p_time))
						WHERE ls_id = p_ls_id
						AND l_inidatetime >= _inidatetime
						AND l_inidatetime >= sysdate();
				UPDATE lecture_schedule
					SET ls_inidatetime = concat(DATE(ls_inidatetime), ' ', TIME(p_time))
					WHERE ls_id = p_ls_id;
			END;
		WHEN 3 THEN
			BEGIN				
				UPDATE lecture
					SET l_inidatetime = concat(DATE(l_inidatetime), ' ', TIME(p_time))
					WHERE ls_id = p_ls_id
					AND l_inidatetime >= sysdate();
				UPDATE lecture_schedule
					SET ls_inidatetime = concat(DATE(ls_inidatetime), ' ', TIME(p_time))
					WHERE ls_id = p_ls_id;
			END;
	END CASE;
END//
DELIMITER ;

/*
DELIMITER //
CREATE PROCEDURE sp_update_ls_repeats(
	IN p_ls_id INT UNSIGNED,
	IN p_ls_repeats INT UNSIGNED)
BEGIN
	DECLARE _counter INT DEFAULT 0;
	DECLARE _inidatetime DATETIME;
	DECLARE _repeats INT UNSIGNED;
	DECLARE _duration INT UNSIGNED;
	DECLARE _intervals INT UNSIGNED;
	SELECT ls_inidatetime, ls_repeats, ls_duration, ls_intervals
		INTO _inidatetime, _repeats, _duration, _intervals
		FROM lecture_schedule
		WHERE ls_id = p_ls_id;
	IF p_ls_repeats > _repeats THEN
		SET _counter = _repeats;
		loop1: LOOP
			SET _counter = _counter + 1;
			INSERT INTO lecture VALUES 
				(p_ls_id, _counter, _inidatetime + INTERVAL (_counter - 1) * _intervals DAY,
				_duration, 0, '', floor(rand() * 10000), floor(rand() * 10000));
			IF _counter < p_ls_repeats THEN ITERATE loop1;
			END IF;
			LEAVE loop1;
		END LOOP loop1;
		UPDATE lecture_schedule
		SET ls_repeats = p_ls_repeats
		WHERE ls_id = p_ls_id;
	ELSEIF p_ls_repeats < _repeats && p_ls_repeats >= 1 THEN
		SET _counter = _repeats - p_ls_repeats; 
		DELETE 
			FROM lecture 
			WHERE ls_id = p_ls_id 
			AND l_inidatetime > sysdate()
			ORDER BY l_inidatetime DESC
			LIMIT _counter;
		UPDATE lecture_schedule
			SET ls_repeats =
				(SELECT count(*)
					FROM lecture
					WHERE ls_id = p_ls_id)
			WHERE ls_id = p_ls_id;
	END IF;  
END//
DELIMITER ;
*/

DELIMITER //
CREATE PROCEDURE sp_delete_ms(
	IN p_ms_id INT UNSIGNED)
BEGIN
	DECLARE _repeats INT UNSIGNED;
	DELETE FROM meeting 
		WHERE ms_id = p_ms_id 
		AND m_inidatetime > sysdate();
	SELECT count(*) INTO _repeats
		FROM meeting
			WHERE ms_id = p_ms_id;
	IF _repeats = 0 THEN
		DELETE FROM meeting_schedule
			WHERE ms_id = p_ms_id;
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_delete_ls(
	IN p_ls_id INT UNSIGNED)
BEGIN
	DECLARE _repeats INT UNSIGNED;
	DELETE FROM lecture 
		WHERE ls_id = p_ls_id
		AND l_inidatetime > sysdate();
	SELECT count(*) INTO _repeats
		FROM lecture
		WHERE ls_id = p_ls_id;
	IF _repeats = 0 THEN
		DELETE FROM lecture_schedule
			WHERE ls_id = p_ls_id;
	END IF;
END//
DELIMITER ;

INSERT INTO predefined_role VALUES ('employee', b'11');
INSERT INTO predefined_role VALUES ('student', b'01');
INSERT INTO predefined_role VALUES ('guest', b'00');

INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'employee', b'11');
INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'student', b'01');
INSERT INTO user_role VALUES (fn_next_id('next_ur_id'), 'guest', b'00');

INSERT INTO bbb_user VALUES ('Admin_Master', 'Admin_Master', 0, 1, NULL, sysdate(), 0, 1, 1, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('Guest_01', 'Guest01', 0, 1, NULL, sysdate(), 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('Guest_02', 'Guest02', 0, 1, NULL, sysdate(), 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('Guest_03', 'Guest03', 0, 1, NULL, sysdate(), 0, 0, 3, b'001', b'0011001');

INSERT INTO non_ldap_user VALUES ('Admin_Master', 'Seneca', 'Master', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', '3dad4112be64b0bdca3f6f545ac862582b92a2207d2a85bc', 'placeholder', SYSDATE());
INSERT INTO non_ldap_user VALUES ('Guest_01', 'Seneca', 'Guest', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'placeholder', SYSDATE());
INSERT INTO non_ldap_user VALUES ('Guest_02', 'Seneca', 'Guest', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'placeholder', SYSDATE());
INSERT INTO non_ldap_user VALUES ('Guest_03', 'Seneca', 'Guest', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'placeholder', SYSDATE());


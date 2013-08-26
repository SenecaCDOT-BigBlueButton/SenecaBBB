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
DROP PROCEDURE IF EXISTS sp_update_m_duration;
DROP PROCEDURE IF EXISTS sp_update_ms_repeats;
DROP PROCEDURE IF EXISTS sp_update_ms_inidatetime;
DROP PROCEDURE IF EXISTS sp_update_m_time;
DROP PROCEDURE IF EXISTS sp_create_ls;
DROP PROCEDURE IF EXISTS sp_update_ls_inidatetime;
DROP PROCEDURE IF EXISTS sp_update_l_duration;
DROP PROCEDURE IF EXISTS sp_update_l_time;
DROP PROCEDURE IF EXISTS sp_update_ls_repeats;
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

/*
  p_ms_inidatetime must be in format
  'YYYY-MM-DD HH:MM:SS'
*/
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

/*
  p_ms_inidatetime must be in format
  'YYYY-MM-DD HH:MM:SS'
*/
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
	IF _repeats > 0 THEN
		UPDATE meeting_schedule
			SET ms_repeats = _repeats
			WHERE ms_id = p_ms_id;
	ELSE
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
	IF _repeats > 0 THEN
		UPDATE lecture_schedule
			SET ls_repeats = _repeats
			WHERE ls_id = p_ls_id;
	ELSE
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



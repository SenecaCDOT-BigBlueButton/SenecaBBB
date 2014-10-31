/*
WARNING: If meeting and lecture schedule datetime in database is UTC already, DO NOT use this script!!!
If the scheduled datetime in database is local datatime, you can run this script and convert to UTC.

1. By default, the local timezone is 'America/New_York', please replace it with your local timezone
2. Make sure to set mysql default timezone to UTC and backup your database
3. Make sure you have populated mysql.time_zone_name table to your mysql server
4. Run the script: mysql -u root -p db < bbb_db_convertToUTC.sql
*/


# Convert m_inidatetime to utc in meeting table

DELIMITER //
DROP PROCEDURE IF EXISTS mlocal_to_utc //
CREATE PROCEDURE mlocal_to_utc()
BEGIN	
	DECLARE done INT DEFAULT 0;
	DECLARE currentRowDatetime DATETIME;
	DECLARE currentRowMsId INT;
	DECLARE currentRowMId INT;
	DECLARE meetingCursor CURSOR FOR SELECT ms_id,m_id,m_inidatetime FROM meeting;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN meetingCursor;
	read_loop: LOOP
		IF done THEN
			LEAVE read_loop;
		END IF;
		FETCH meetingCursor INTO currentRowMsId,currentRowMId,currentRowDatetime;
		UPDATE meeting SET m_inidatetime = CONVERT_TZ(currentRowDatetime,'America/New_York','UTC')
		WHERE ms_id = currentRowMsId
		AND m_id = currentRowMId;
	END LOOP read_loop;
	CLOSE meetingCursor;
END//
DELIMITER ;
CALL mlocal_to_utc();

# Convert ms_inidatetime to utc in meeting_schedule table

DELIMITER //
DROP PROCEDURE IF EXISTS mslocal_to_utc //
CREATE PROCEDURE mslocal_to_utc()
BEGIN	
	DECLARE done INT DEFAULT 0;
	DECLARE currentRowDatetime DATETIME;
	DECLARE currentRowMsId INT;
	DECLARE meetingScheduleCursor CURSOR FOR SELECT ms_id,ms_inidatetime FROM meeting_schedule;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN meetingScheduleCursor;
	read_loop: LOOP
		IF done THEN
			LEAVE read_loop;
		END IF;
		FETCH meetingScheduleCursor INTO currentRowMsId,currentRowDatetime;
		UPDATE meeting_schedule SET ms_inidatetime = CONVERT_TZ(currentRowDatetime,'America/New_York','UTC')
		WHERE ms_id = currentRowMsId;
	END LOOP read_loop;
	CLOSE meetingScheduleCursor;
END//
DELIMITER ;
CALL mslocal_to_utc();

# Convert l_inidatetime to utc in lecture table

DELIMITER //
DROP PROCEDURE IF EXISTS lecture_local_to_utc //
CREATE PROCEDURE lecture_local_to_utc()
BEGIN	
	DECLARE done INT DEFAULT 0;
	DECLARE currentRowDatetime DATETIME;
	DECLARE currentRowLsId INT;
	DECLARE currentRowLId INT;
	DECLARE lectureCursor CURSOR FOR SELECT ls_id,l_id,l_inidatetime FROM lecture;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN lectureCursor;
	read_loop: LOOP
		IF done THEN
			LEAVE read_loop;
		END IF;
		FETCH lectureCursor INTO currentRowLsId,currentRowLId,currentRowDatetime;
		UPDATE lecture SET l_inidatetime = CONVERT_TZ(currentRowDatetime,'America/New_York','UTC')
		WHERE ls_id = currentRowLsId
		AND l_id = currentRowLId;
	END LOOP read_loop;
	CLOSE lectureCursor;
END//
DELIMITER ;
CALL lecture_local_to_utc();

# Convert ls_inidatetime to utc in lecture_schedule table

DELIMITER //
DROP PROCEDURE IF EXISTS lectureSchedule_local_to_utc //
CREATE PROCEDURE lectureSchedule_local_to_utc()
BEGIN	
	DECLARE done INT DEFAULT 0;
	DECLARE currentRowDatetime DATETIME;
	DECLARE currentRowLsId INT;
	DECLARE lectureScheduleCursor CURSOR FOR SELECT ls_id,ls_inidatetime FROM lecture_schedule;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN lectureScheduleCursor;
	read_loop: LOOP
		IF done THEN
			LEAVE read_loop;
		END IF;
		FETCH lectureScheduleCursor INTO currentRowLsId,currentRowDatetime;
		UPDATE lecture_schedule SET ls_inidatetime = CONVERT_TZ(currentRowDatetime,'America/New_York','UTC')
		WHERE ls_id = currentRowLsId;
	END LOOP read_loop;
	CLOSE lectureScheduleCursor;
END//
DELIMITER ;
CALL lectureSchedule_local_to_utc();

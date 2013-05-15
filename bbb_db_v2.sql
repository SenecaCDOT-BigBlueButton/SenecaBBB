/*
  V 0.2
  all column name that has a '_is' part is binary and uses BIT(1) for column type
  -Bo Li
*/

/* with mysql, there is now a particular order you must drop these tables now
   parent table must be dropped before child table
*/
DROP TABLE IF EXISTS bbb_admin CASCADE;
DROP TABLE IF EXISTS guest_lecturer CASCADE;
DROP TABLE IF EXISTS lecture CASCADE;
DROP TABLE IF EXISTS lecture_presentation CASCADE;
DROP TABLE IF EXISTS lecture_schedule CASCADE;
DROP TABLE IF EXISTS meeting_attendee CASCADE;
DROP TABLE IF EXISTS meeting_guest CASCADE;
DROP TABLE IF EXISTS meeting_presentation CASCADE;
DROP TABLE IF EXISTS meeting CASCADE;
DROP TABLE IF EXISTS meeting_schedule CASCADE;
DROP TABLE IF EXISTS predefined_role CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS section CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS subject CASCADE;
DROP TABLE IF EXISTS user_info CASCADE;
DROP TABLE IF EXISTS bbb_user CASCADE;
DROP TABLE IF EXISTS user_role CASCADE;

# admin is future keyword, using bbb_admin instead
CREATE TABLE bbb_admin (
  next_m_id       MEDIUMINT UNSIGNED,
  next_ms_id      MEDIUMINT UNSIGNED
);

CREATE TABLE user_role (
  ur_id           MEDIUMINT UNSIGNED AUTO_INCREMENT,
  ur_name         VARCHAR(50),
  ur_rolemask     BIT(10),
  CONSTRAINT pk_user_role 
    PRIMARY KEY (ur_id),
  CONSTRAINT uq_ur_name
    UNIQUE (ur_name)
);

# user is keyword, using bbb_user instead
CREATE TABLE bbb_user ( 
  u_id            VARCHAR(50),
  u_isbanned      BIT(1),
  u_isactive      BIT(1),
  u_comment       VARCHAR(2000),
  u_lastlogin     DATETIME,
  u_isldap        BIT(1),
  u_isadmin       BIT(1),
  ur_id           MEDIUMINT UNSIGNED,
  CONSTRAINT pk_user 
    PRIMARY KEY (u_id),
  CONSTRAINT fk_user_role_of_user
    FOREIGN KEY (ur_id) 
    REFERENCES user_role (ur_id)
    # user is not deleted even if there is no role for him/her
    ON DELETE SET NULL
	ON UPDATE CASCADE
);

CREATE TABLE meeting_schedule (
  ms_id           MEDIUMINT UNSIGNED AUTO_INCREMENT,
  ms_intdatetime  DATETIME,
  ms_intervals    MEDIUMINT UNSIGNED,
  ms_repeats      MEDIUMINT UNSIGNED,
  ms_duration     MEDIUMINT UNSIGNED,
  u_id            VARCHAR(50),
  CONSTRAINT pk_meeting_schedule 
    PRIMARY KEY (ms_id),
  CONSTRAINT fk_bbb_user_of_meeting_schedule
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE predefined_role (
  pr_name         VARCHAR(50),
  pr_rolepattern  BIT(10),
  CONSTRAINT pk_predefined_role
    PRIMARY KEY (pr_name)
);

CREATE TABLE user_info (
  u_id            VARCHAR(50),
  ui_name         VARCHAR(50),
  ui_lastname     VARCHAR(50),
  ui_salt         VARCHAR(50),
  ui_hash         VARCHAR(50),
  ui_email        VARCHAR(100),
  CONSTRAINT pk_user_info 
    PRIMARY KEY (u_id),
  CONSTRAINT fk_bbb_user_of_user_info
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE meeting (
  m_id            MEDIUMINT UNSIGNED AUTO_INCREMENT,
  m_intdatetime   DATETIME NOT NULL,
  m_duration      MEDIUMINT UNSIGNED NOT NULL,
  ms_id           MEDIUMINT UNSIGNED,
  CONSTRAINT pk_meeting 
    PRIMARY KEY (m_id),
  CONSTRAINT fk_meeting_schedule_of_meeting
    FOREIGN KEY (ms_id) 
    REFERENCES meeting_schedule (ms_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_presentation (
  m_id            MEDIUMINT UNSIGNED,
  mp_title        VARCHAR(100),
  CONSTRAINT pk_meeting_presentation 
    PRIMARY KEY (m_id, mp_title),
  CONSTRAINT fk_meeting_of_meeting_presentation
    FOREIGN KEY (m_id) 
    REFERENCES meeting (m_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_guest (
  u_id            VARCHAR(50),
  m_id            MEDIUMINT UNSIGNED,
  mg_ismod        BIT(1),
  CONSTRAINT pk_meeting_guest 
    PRIMARY KEY (u_id, m_id),
  CONSTRAINT fk_bbb_user_of_meeting_guest
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT fk_meeting_of_meeting_guest
    FOREIGN KEY (m_id) 
    REFERENCES meeting (m_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_attendee (
  u_id            VARCHAR(50),
  ms_id           MEDIUMINT UNSIGNED,
  ma_ismod        BIT(1),
  CONSTRAINT pk_meeting_attendee 
    PRIMARY KEY (u_id, ms_id),
  CONSTRAINT fk_bbb_user_of_meeting_attendee
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT fk_meeting_schedule_of_meeting_attendee
    FOREIGN KEY (ms_id) 
    REFERENCES meeting_schedule (ms_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
/*
CREATE TABLE Subject (
  --changed sub_id type to CHAR
  sub_id          CHAR(6),
  sub_name        VARCHAR2(256),
  CONSTRAINT Subject_PK 
    PRIMARY KEY (sub_id)
);

CREATE TABLE Section (
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  s_modpass       CHAR(10),
  s_viewpass      CHAR(10),
  s_guest         CHAR(10),
  s_mul_draw      CHAR(10),
  s_meeting_id    CHAR(10),
  s_recorded      CHAR(10),
  CONSTRAINT Section_PK 
    PRIMARY KEY (sub_id, sc_id),
  CONSTRAINT Subject_Section_FK
    FOREIGN KEY (sub_id) 
    REFERENCES Subject (sub_id)
    ON DELETE CASCADE
);

CREATE TABLE Professor (
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  --changed u_id to VARCHAR2 from CHAR to match column type in Users
  u_id            VARCHAR2(40),
  CONSTRAINT Professor_PK 
    PRIMARY KEY (sub_id, sc_id, u_id),
  CONSTRAINT Section_Professor_FK
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES Section (sub_id, sc_id)
    ON DELETE CASCADE,
  CONSTRAINT Users_Professor_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE  
);

CREATE TABLE Student (
  --changed sub_id, sc_id to CHAR 
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  u_id            VARCHAR2(40),
  s_banned        CHAR(10),
  CONSTRAINT Student_PK 
    PRIMARY KEY (sub_id, sc_id, u_id),
  CONSTRAINT Section_Student_FK
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES Section (sub_id, sc_id)
    ON DELETE CASCADE,
  CONSTRAINT Users_Student_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE  
);

CREATE TABLE Lecture_Schedule (
  ls_id           CHAR(10),
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  ls_intDateTime  CHAR(10),
  ls_intervals    CHAR(10),
  ls_repeats      CHAR(10),
  ls_duration     CHAR(10),
  CONSTRAINT Lecture_Schedule_PK 
    PRIMARY KEY (ls_id, sub_id, sc_id),
  CONSTRAINT Section_Lecture_Schedule_FK
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES Section (sub_id, sc_id)
    ON DELETE CASCADE
);
  
CREATE TABLE Lecture (
  --changed l_id type to NUMBER from NUMBERPS
  l_id            NUMBER(38,0),
  ls_id           CHAR(10),
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  l_duration      CHAR(10),
  l_cancel        CHAR(10),
  l_comments      CHAR(10),
  l_url           CHAR(10),
  CONSTRAINT Lecture_PK 
    PRIMARY KEY (l_id, ls_id, sub_id, sc_id),
  CONSTRAINT Lecture_Schedule_Lecture_FK
    FOREIGN KEY (sub_id, sc_id, ls_id) 
    REFERENCES Lecture_Schedule (sub_id, sc_id, ls_id)
    ON DELETE CASCADE
);

CREATE TABLE Lecture_Presentations (
  lp_title        CHAR(10),
  l_id            NUMBER(38,0),
  ls_id           CHAR(10),
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  CONSTRAINT Lecture_Presentations_PK 
    PRIMARY KEY (lp_title, l_id, ls_id, sub_id, sc_id),
  CONSTRAINT Lecture_LPresentations_FK
    FOREIGN KEY (sub_id, sc_id, ls_id, l_id) 
    REFERENCES Lecture (sub_id, sc_id, ls_id, l_id)
    ON DELETE CASCADE
);

CREATE TABLE Guest_Lecturer (
  u_id            VARCHAR2(40),
  l_id            NUMBER(38,0),
  ls_id           CHAR(10),
  sub_id          CHAR(6),
  sc_id           CHAR(2),
  gl_ismod        CHAR(1),
  CONSTRAINT Guest_Lecturer_PK 
    PRIMARY KEY (u_id, l_id, ls_id, sub_id, sc_id),
  CONSTRAINT Lecture_GLecturer_FK
    FOREIGN KEY (sub_id, sc_id, ls_id, l_id) 
    REFERENCES Lecture (sub_id, sc_id, ls_id, l_id)
    ON DELETE CASCADE,
  CONSTRAINT Users_GLecturer_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE
);
 */ 
  
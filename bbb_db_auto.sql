/*
  V 0.2
  all column name that has a '_is' part is binary and uses BIT(1) for column type
  this script uses AUTO_INCREMENT to generate primary keys for tables:
        user_role
        meeting
        meeting_schedule
        lecture
        lecture_schedule
  -Bo Li
*/
DROP TABLE IF EXISTS guest_lecturer CASCADE;
DROP TABLE IF EXISTS lecture_presentation CASCADE;
DROP TABLE IF EXISTS lecture CASCADE;
DROP TABLE IF EXISTS lecture_schedule CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS section CASCADE;
DROP TABLE IF EXISTS subject CASCADE;
DROP TABLE IF EXISTS meeting_attendee CASCADE;
DROP TABLE IF EXISTS meeting_guest CASCADE;
DROP TABLE IF EXISTS meeting_presentation CASCADE;
DROP TABLE IF EXISTS meeting CASCADE;
DROP TABLE IF EXISTS user_info CASCADE;
DROP TABLE IF EXISTS predefined_role CASCADE;
DROP TABLE IF EXISTS meeting_schedule CASCADE;
DROP TABLE IF EXISTS bbb_user CASCADE;
DROP TABLE IF EXISTS user_role CASCADE;
DROP TABLE IF EXISTS bbb_admin CASCADE;

# admin is future keyword, using bbb_admin instead
CREATE TABLE bbb_admin (
  row_num         TINYINT,
  next_m_id       MEDIUMINT UNSIGNED,
  next_ms_id      MEDIUMINT UNSIGNED,
  next_l_id       MEDIUMINT UNSIGNED,
  next_ls_id      MEDIUMINT UNSIGNED,
  next_ur_id      MEDIUMINT UNSIGNED,
  CONSTRAINT pk_bbb_admin
    PRIMARY KEY (row_num)
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
  m_iscancel      BIT(1),
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

CREATE TABLE subject (
  sub_id          CHAR(8),
  sub_name        VARCHAR(100),
  CONSTRAINT pk_subject 
    PRIMARY KEY (sub_id)
);

CREATE TABLE section (
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  s_modpass       VARCHAR(50),
  s_viewpass      VARCHAR(50),
  s_ismuldraw     BIT(1),
  #s_meetingid    MEDIUMINT UNSIGNED,
  s_isrecorded    BIT(1),
  CONSTRAINT pk_section 
    PRIMARY KEY (sub_id, sc_id),
  CONSTRAINT fk_subject_of_section
    FOREIGN KEY (sub_id) 
    REFERENCES subject (sub_id)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE professor (
  u_id            VARCHAR(50),
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  CONSTRAINT pk_professor 
    PRIMARY KEY (sub_id, sc_id, u_id),
  CONSTRAINT fk_section_of_professor
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES section (sub_id, sc_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_professor
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE  
);

CREATE TABLE student (
  u_id            VARCHAR(50), 
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  s_isbanned      BIT(1),
  CONSTRAINT pk_student 
    PRIMARY KEY (sub_id, sc_id, u_id),
  CONSTRAINT fk_section_of_student
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES section (sub_id, sc_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_student
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE  
);

CREATE TABLE lecture_schedule (
  ls_id           MEDIUMINT UNSIGNED AUTO_INCREMENT,
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  ls_intdatetime  DATETIME,
  ls_intervals    MEDIUMINT UNSIGNED,
  ls_repeats      MEDIUMINT UNSIGNED,
  ls_duration     MEDIUMINT UNSIGNED,
  CONSTRAINT pk_lecture_schedule 
    PRIMARY KEY (ls_id, sub_id, sc_id),
  CONSTRAINT fk_section_of_lecture_schedule
    FOREIGN KEY (sub_id, sc_id) 
    REFERENCES section (sub_id, sc_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
  
CREATE TABLE lecture (
  l_id            MEDIUMINT UNSIGNED AUTO_INCREMENT,
  ls_id           MEDIUMINT UNSIGNED,
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  l_intdatetime   DATETIME NOT NULL,
  l_duration      MEDIUMINT UNSIGNED NOT NULL,
  l_iscancel      BIT(1),
  l_comment       VARCHAR(2000),
  #l_url          VARCHAR(100),
  CONSTRAINT pk_lecture 
    PRIMARY KEY (l_id, ls_id, sub_id, sc_id),
  CONSTRAINT fk_lecture_schedule_of_lecture
    FOREIGN KEY (sub_id, sc_id, ls_id) 
    REFERENCES lecture_schedule (sub_id, sc_id, ls_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE lecture_presentation (
  lp_title        VARCHAR(100),
  l_id            MEDIUMINT UNSIGNED,
  ls_id           MEDIUMINT UNSIGNED,
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  CONSTRAINT pk_lecture_presentation 
    PRIMARY KEY (lp_title, l_id, ls_id, sub_id, sc_id),
  CONSTRAINT fk_lecture_of_lecture_presentation
    FOREIGN KEY (sub_id, sc_id, ls_id, l_id) 
    REFERENCES lecture (sub_id, sc_id, ls_id, l_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE guest_lecturer (
  u_id            VARCHAR(50),
  l_id            MEDIUMINT UNSIGNED,
  ls_id           MEDIUMINT UNSIGNED,
  sub_id          CHAR(8),
  sc_id           CHAR(2),
  gl_ismod        BIT(1),
  CONSTRAINT pk_guest_lecturer 
    PRIMARY KEY (u_id, l_id, ls_id, sub_id, sc_id),
  CONSTRAINT fk_lecture_of_guest_lecturer
    FOREIGN KEY (sub_id, sc_id, ls_id, l_id) 
    REFERENCES lecture (sub_id, sc_id, ls_id, l_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_guest_lecturer
    FOREIGN KEY (u_id) 
    REFERENCES bbb_user (u_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
  
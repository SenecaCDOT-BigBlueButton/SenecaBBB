/*
  V 0.2
  all column name that has a '_is' part is binary and uses BIT(1) for column type
  this script uses table 'bbb_admin' to generate primary keys for tables:
        user_role
        meeting_schedule
        lecture_schedule

  ls_id is always put before l_id
  ms_id is always put before m_id

  -Bo Li
*/

DROP TABLE IF EXISTS lecture_attendance CASCADE;
DROP TABLE IF EXISTS guest_lecturer CASCADE;
DROP TABLE IF EXISTS lecture_presentation CASCADE;
DROP TABLE IF EXISTS lecture CASCADE;
DROP TABLE IF EXISTS lecture_schedule CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS section CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS meeting_attendance CASCADE;
DROP TABLE IF EXISTS meeting_attendee CASCADE;
DROP TABLE IF EXISTS meeting_guest CASCADE;
DROP TABLE IF EXISTS meeting_presentation CASCADE;
DROP TABLE IF EXISTS meeting CASCADE;
DROP TABLE IF EXISTS non_ldap_user CASCADE;
DROP TABLE IF EXISTS meeting_schedule CASCADE;
DROP TABLE IF EXISTS user_department CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS bbb_user CASCADE;
DROP TABLE IF EXISTS user_role CASCADE;
DROP TABLE IF EXISTS bbb_admin CASCADE;
DROP TABLE IF EXISTS predefined_role CASCADE;

# AsOf Table
CREATE TABLE predefined_role (
  pr_name         VARCHAR(100) NOT NULL,
  pr_defaultmask  BIT(20) NOT NULL,
  CONSTRAINT pk_predefined_role
    PRIMARY KEY (pr_name)
);

# admin is future keyword, using bbb_admin instead
CREATE TABLE bbb_admin (
  key_name        VARCHAR(50),
  key_title       VARCHAR(100) NOT NULL,
  key_value       VARCHAR(300) NOT NULL,
  CONSTRAINT pk_bbb_admin
    PRIMARY KEY (key_name)
);

CREATE TABLE user_role (
  ur_id           INT UNSIGNED,
  pr_name         VARCHAR(100) NOT NULL,
  ur_rolemask     BIT(20) NOT NULL,
  CONSTRAINT pk_user_role 
    PRIMARY KEY (ur_id),
  CONSTRAINT fk_predefined_role_of_user_role
    FOREIGN KEY (pr_name)
    REFERENCES predefined_role (pr_name)
    #ON DELETE CASCADE
    ON UPDATE CASCADE

);

# user is keyword, using bbb_user instead
CREATE TABLE bbb_user ( 
  bu_id           VARCHAR(100),
  bu_nick         VARCHAR(100) NOT NULL,
  bu_isbanned     BIT(1) NOT NULL,
  bu_isactive     BIT(1) NOT NULL,
  bu_comment      VARCHAR(2000),
  bu_lastlogin    DATETIME,
  bu_isldap       BIT(1) NOT NULL,
  bu_issuper      BIT(1) NOT NULL,
  ur_id           INT UNSIGNED,
  bu_setting      BIT(20) NOT NULL,
  m_setting       BIT(20) NOT NULL,
  CONSTRAINT pk_user 
    PRIMARY KEY (bu_id),
  CONSTRAINT fk_user_role_of_user
    FOREIGN KEY (ur_id) 
    REFERENCES user_role (ur_id)
    # user is not deleted even if there is no role for him/her
    #ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE department (
  d_code          CHAR(5),
  d_name          VARCHAR(100) NOT NULL,
  CONSTRAINT pk_department
    PRIMARY KEY (d_code)
);

CREATE TABLE user_department (
  bu_id           VARCHAR(100),
  d_code          CHAR(5),
  ud_isadmin      BIT(1) NOT NULL,
  CONSTRAINT pk_user_department 
    PRIMARY KEY (bu_id, d_code),
  CONSTRAINT fk_bbb_user_of_user_department
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_department_of_user_department
    FOREIGN KEY (d_code) 
    REFERENCES department (d_code)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_schedule (
  ms_id           INT UNSIGNED,
  ms_title        VARCHAR(100) NOT NULL,
  ms_inidatetime  DATETIME NOT NULL,
  ms_intervals    INT UNSIGNED NOT NULL,
  ms_repeats      INT UNSIGNED NOT NULL,
  ms_duration     INT UNSIGNED NOT NULL,
  bu_id           VARCHAR(100) NOT NULL,
  CONSTRAINT pk_meeting_schedule 
    PRIMARY KEY (ms_id),
  CONSTRAINT fk_bbb_user_of_meeting_schedule
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE non_ldap_user (
  bu_id           VARCHAR(100),
  nu_name         VARCHAR(100) NOT NULL,
  nu_lastname     VARCHAR(100) NOT NULL,
  nu_salt         VARCHAR(100) NOT NULL,
  nu_hash         VARCHAR(100) NOT NULL,
  nu_email        VARCHAR(100) NOT NULL,
  nu_createtime   DATETIME NOT NULL,
  CONSTRAINT pk_non_ldap_user 
    PRIMARY KEY (bu_id),
  CONSTRAINT fk_bbb_user_of_non_ldap_user
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting (
  ms_id           INT UNSIGNED,
  m_id            INT UNSIGNED,
  m_inidatetime   DATETIME NOT NULL,
  m_duration      INT UNSIGNED NOT NULL,
  m_iscancel      BIT(1) NOT NULL,
  m_description   VARCHAR(2000),
  #m_isrecorded    BIT(1) NOT NULL, now part of the m_setting
  m_modpass       CHAR(15) NOT NULL,
  m_userpass      CHAR(15) NOT NULL,
  m_setting       BIT(20) NOT NULL,
  CONSTRAINT pk_meeting 
    PRIMARY KEY (m_id, ms_id),
  CONSTRAINT fk_meeting_schedule_of_meeting
    FOREIGN KEY (ms_id) 
    REFERENCES meeting_schedule (ms_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_presentation (
  mp_title        VARCHAR(100),
  ms_id           INT UNSIGNED,
  m_id            INT UNSIGNED,
  CONSTRAINT pk_meeting_presentation 
    PRIMARY KEY (ms_id, m_id, mp_title),
  CONSTRAINT fk_meeting_of_meeting_presentation
    FOREIGN KEY (ms_id, m_id) 
    REFERENCES meeting (ms_id, m_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_guest (
  bu_id           VARCHAR(100),
  ms_id           INT UNSIGNED,
  m_id            INT UNSIGNED,
  mg_ismod        BIT(1) NOT NULL,
  CONSTRAINT pk_meeting_guest 
    PRIMARY KEY (bu_id, ms_id, m_id),
  CONSTRAINT fk_bbb_user_of_meeting_guest
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_meeting_of_meeting_guest
    FOREIGN KEY (ms_id, m_id) 
    REFERENCES meeting (ms_id, m_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE meeting_attendee (
  bu_id           VARCHAR(100),
  ms_id           INT UNSIGNED,
  ma_ismod        BIT(1) NOT NULL,
  CONSTRAINT pk_meeting_attendee 
    PRIMARY KEY (bu_id, ms_id),
  CONSTRAINT fk_bbb_user_of_meeting_attendee
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_meeting_schedule_of_meeting_attendee
    FOREIGN KEY (ms_id) 
    REFERENCES meeting_schedule (ms_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# may not be used in Integration v1.0
CREATE TABLE meeting_attendance (
  bu_id           VARCHAR(100),
  ms_id           INT UNSIGNED,
  m_id            INT UNSIGNED,
  mac_isattend    BIT(1) NOT NULL,
  CONSTRAINT pk_meeting_attendance 
    PRIMARY KEY (bu_id, ms_id, m_id),
  CONSTRAINT fk_bbb_user_of_meeting_attendance
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_meeting_of_meeting_attendance
    FOREIGN KEY (m_id, ms_id) 
    REFERENCES meeting (m_id, ms_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE course (
  c_id            CHAR(8),
  c_name          VARCHAR(100) NOT NULL,
  CONSTRAINT pk_course 
    PRIMARY KEY (c_id)
);

CREATE TABLE section (
  c_id            CHAR(8),
  sc_id           CHAR(2),
  sc_semesterid   INT UNSIGNED,
  # sc_ismuldraw    BIT(1) NOT NULL, now part of sc_setting in professor table
  # sc_isrecorded   BIT(1) NOT NULL, now part of sc_setting in professor table
  d_code          CHAR(5) NOT NULL,
  CONSTRAINT pk_section 
    PRIMARY KEY (c_id, sc_id, sc_semesterid),
  CONSTRAINT fk_course_of_section
    FOREIGN KEY (c_id) 
    REFERENCES course (c_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_department_of_section
    FOREIGN KEY (d_code) 
    REFERENCES department (d_code)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE professor (
  bu_id           VARCHAR(100),
  c_id            CHAR(8),
  sc_id           CHAR(2),
  sc_semesterid   INT UNSIGNED,
  sc_setting      BIT(20) NOT NULL,
  CONSTRAINT pk_professor 
    PRIMARY KEY (c_id, sc_id, sc_semesterid, bu_id),
  CONSTRAINT fk_section_of_professor
    FOREIGN KEY (c_id, sc_id, sc_semesterid) 
    REFERENCES section (c_id, sc_id, sc_semesterid)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_professor
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE  
);

CREATE TABLE student (
  bu_id           VARCHAR(100), 
  c_id            CHAR(8),
  sc_id           CHAR(2),
  sc_semesterid   INT UNSIGNED,
  s_isbanned      BIT(1) NOT NULL,
  CONSTRAINT pk_student 
    PRIMARY KEY (c_id, sc_id, sc_semesterid, bu_id),
  CONSTRAINT fk_section_of_student
    FOREIGN KEY (c_id, sc_id, sc_semesterid) 
    REFERENCES section (c_id, sc_id, sc_semesterid)
    #ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_student
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE  
);

CREATE TABLE lecture_schedule (
  ls_id           INT UNSIGNED,
  c_id            CHAR(8) NOT NULL,
  sc_id           CHAR(2) NOT NULL,
  sc_semesterid   INT UNSIGNED NOT NULL,
  ls_inidatetime  DATETIME NOT NULL,
  ls_intervals    INT UNSIGNED NOT NULL,
  ls_repeats      INT UNSIGNED NOT NULL,
  ls_duration     INT UNSIGNED NOT NULL,
  #ls_isrecorded   BIT(1), part of sc_setting
  CONSTRAINT pk_lecture_schedule 
    PRIMARY KEY (ls_id),
  CONSTRAINT fk_section_of_lecture_schedule
    FOREIGN KEY (c_id, sc_id, sc_semesterid) 
    REFERENCES section (c_id, sc_id, sc_semesterid)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);
  
CREATE TABLE lecture (
  ls_id           INT UNSIGNED,
  l_id            INT UNSIGNED,
  l_inidatetime   DATETIME NOT NULL,
  l_duration      INT UNSIGNED NOT NULL,
  l_iscancel      BIT(1) NOT NULL,
  l_description   VARCHAR(2000),
  l_modpass       CHAR(15) NOT NULL,
  l_userpass      CHAR(15) NOT NULL,
  #l_isrecorded    BIT(1), part of sc_setting
  #l_url          VARCHAR(100),
  CONSTRAINT pk_lecture 
    PRIMARY KEY (l_id, ls_id),
  CONSTRAINT fk_lecture_schedule_of_lecture
    FOREIGN KEY (ls_id) 
    REFERENCES lecture_schedule (ls_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE lecture_presentation (
  lp_title        VARCHAR(100),
  ls_id           INT UNSIGNED,
  l_id            INT UNSIGNED,
  CONSTRAINT pk_lecture_presentation 
    PRIMARY KEY (lp_title, l_id, ls_id),
  CONSTRAINT fk_lecture_of_lecture_presentation
    FOREIGN KEY (ls_id, l_id) 
    REFERENCES lecture (ls_id, l_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE guest_lecturer (
  bu_id           VARCHAR(100),
  ls_id           INT UNSIGNED,
  l_id            INT UNSIGNED,
  gl_ismod        BIT(1) NOT NULL,
  CONSTRAINT pk_guest_lecturer 
    PRIMARY KEY (bu_id, l_id, ls_id),
  CONSTRAINT fk_lecture_of_guest_lecturer
    FOREIGN KEY (ls_id, l_id) 
    REFERENCES lecture (ls_id, l_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_bbb_user_of_guest_lecturer
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
    ON UPDATE CASCADE
);

# may not be used in Integration v1.0
CREATE TABLE lecture_attendance (
  bu_id           VARCHAR(100),
  ls_id           INT UNSIGNED,
  l_id            INT UNSIGNED,
  la_isattend     BIT(1) NOT NULL,
  CONSTRAINT pk_lecture_attendance 
    PRIMARY KEY (bu_id, ls_id, l_id),
  CONSTRAINT fk_bbb_user_of_lecture_attendance
    FOREIGN KEY (bu_id) 
    REFERENCES bbb_user (bu_id)
    #ON DELETE CASCADE
	ON UPDATE CASCADE,
  CONSTRAINT fk_lecture_of_lecture_attendance
    FOREIGN KEY (l_id, ls_id) 
    REFERENCES lecture (l_id, ls_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
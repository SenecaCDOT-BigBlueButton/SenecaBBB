/*
  V 0.1
  For columns that has only 2 options (e.g. mg_ismod), maybe enum('y','n')
  is better than CHAR(1)
  I abbreviated all subject to sub instead sb
    
  -Bo Li
*/

/* Comment out the DROP statements if creating tables for the first time */
DROP TABLE Guest_Lecturer CASCADE CONSTRAINTS;
DROP TABLE Lecture_Presentations CASCADE CONSTRAINTS;
DROP TABLE Lecture CASCADE CONSTRAINTS;
DROP TABLE Lecture_Schedule CASCADE CONSTRAINTS;
DROP TABLE Student CASCADE CONSTRAINTS;
DROP TABLE Professor CASCADE CONSTRAINTS;
DROP TABLE Section CASCADE CONSTRAINTS;
DROP TABLE Subject CASCADE CONSTRAINTS;
DROP TABLE Meeting_Attendee CASCADE CONSTRAINTS;
DROP TABLE Meeting_Guest CASCADE CONSTRAINTS;
DROP TABLE Meeting_Presentation CASCADE CONSTRAINTS;
DROP TABLE Meeting CASCADE CONSTRAINTS;
DROP TABLE User_Info CASCADE CONSTRAINTS;
DROP TABLE Predefined_Roles CASCADE CONSTRAINTS;
DROP TABLE Meeting_Schedule CASCADE CONSTRAINTS;
DROP TABLE Users CASCADE CONSTRAINTS;
DROP TABLE User_Role CASCADE CONSTRAINTS;
DROP TABLE Admini CASCADE CONSTRAINTS;

--Admin is future keyword, using Admini instead
CREATE TABLE Admini (
  --NUMBERPS cause an error when running script, so I'll use NUMBER for now
  next_m_id       NUMBER(10,0),
  next_ms_id      NUMBER(10,0)
);

CREATE TABLE User_Role (
  ur_id           CHAR(10),
  ur_name         CHAR(10),
  ur_RoleMask     CHAR(10),
  CONSTRAINT User_Role_PK 
    PRIMARY KEY (ur_id),
  CONSTRAINT ur_name_UK
    UNIQUE (ur_name)
);

-- USER is reserved word, so I used Users for table name
CREATE TABLE Users ( 
  --should the id use varchar2(40)?
  u_id            VARCHAR2(40),
  u_banned        VARCHAR2(10),
  u_active        VARCHAR2(10),
  u_comment       VARCHAR2(10),
  u_lastlogin     VARCHAR2(10),
  u_ldap          CHAR(1),
  u_is_admin      CHAR(1),
  ur_id           CHAR(10),
  CONSTRAINT Users_PK 
    PRIMARY KEY (u_id),
  CONSTRAINT User_Role_Users_FK
    FOREIGN KEY (ur_id) 
    REFERENCES User_Role (ur_id)
    --user is not deleted even if there is no role for him/her
    ON DELETE SET NULL
);

--Between this table and Meeting, I think one is not needed
CREATE TABLE Meeting_Schedule (
  ms_id           CHAR(10),
  ls_intDateTime  CHAR(10),
  ls_intervals    CHAR(10),
  ls_repeats      CHAR(10),
  ls_duration     CHAR(10),
  u_id            VARCHAR2(40),
  CONSTRAINT Meeting_Schedule_PK 
    PRIMARY KEY (ms_id),
  CONSTRAINT Users_Meeting_Schedule_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE
    --Without a user, there is no meeting, so meeting is deleted
);
  
CREATE TABLE Predefined_Roles (
  pr_name         CHAR(10),
  pr_RolePattern  CHAR(10),
  CONSTRAINT Predefined_Roles_PK
    PRIMARY KEY (pr_name)
);

--I'm not sure User_Info should be a separate table, instead part of Users
CREATE TABLE User_Info (
  --u_id should be the same length as the u_id in Users, 40 instead of 10
  u_id            VARCHAR2(40),
  ui_name         VARCHAR2(10),
  ui_lastname     VARCHAR2(10),
  ui_salt         VARCHAR2(10),
  ui_hash         VARCHAR2(10),
  ui_email        VARCHAR2(10),
  CONSTRAINT User_Info_PK 
    PRIMARY KEY (u_id),
  CONSTRAINT Users_User_Info_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    --no user info without a user
    ON DELETE CASCADE
);
  
--Between this table and Meeting_Schedule, I think one is not needed
CREATE TABLE Meeting (
  m_id            CHAR(10),
  ls_intDateTime  CHAR(10) NOT NULL,
  ls_duration     CHAR(10) NOT NULL,
  ms_id           CHAR(10),
  CONSTRAINT Meeting_PK 
    PRIMARY KEY (m_id),
  CONSTRAINT Meeting_Schedule_Meeting_FK
    FOREIGN KEY (ms_id) 
    REFERENCES Meeting_Schedule (ms_id)
    ON DELETE CASCADE
);

CREATE TABLE Meeting_Presentation (
  m_id            CHAR(10),
  mp_title        CHAR(10),
  CONSTRAINT Meeting_Presentation_PK 
    PRIMARY KEY (m_id, mp_title),
  --original FK name Meeting_Meeting_Presentation_FK is too long
  CONSTRAINT Meeting_MPresentation_FK
    FOREIGN KEY (m_id) 
    REFERENCES Meeting (m_id)
    --no presentation without meeting
    ON DELETE CASCADE
);

/* 
  if meeting and meeting schedule is merged, then meeting_guest and meeting 
  attendee can also be merged
*/
CREATE TABLE Meeting_Guest (
  u_id            VARCHAR2(40),
  m_id            CHAR(10),
  mg_ismod        CHAR(1),
  CONSTRAINT Meeting_Guest_PK 
    PRIMARY KEY (u_id, m_id),
  CONSTRAINT Users_Meeting_Guest_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE,
  CONSTRAINT Meeting_Meeting_Guest_FK
    FOREIGN KEY (m_id) 
    REFERENCES Meeting (m_id)
    ON DELETE CASCADE
);

CREATE TABLE Meeting_Attendee (
  u_id            VARCHAR2(40),
  ms_id           CHAR(10),
  ma_ismod        CHAR(1),
  CONSTRAINT Meeting_Attendee_PK 
    PRIMARY KEY (u_id, ms_id),
  CONSTRAINT Users_Meeting_Attendee_FK
    FOREIGN KEY (u_id) 
    REFERENCES Users (u_id)
    ON DELETE CASCADE,
  --shortened for DB
  CONSTRAINT MSchedule_MAttendee_FK
    FOREIGN KEY (ms_id) 
    REFERENCES Meeting_Schedule (ms_id)
    ON DELETE CASCADE
);

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
  
  
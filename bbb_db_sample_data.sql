
INSERT INTO predefined_role VALUES ('student', 1);
INSERT INTO predefined_role VALUES ('professor', 1);

INSERT INTO user_role VALUES (fn_next_ur_id(), 'student', 1);
INSERT INTO user_role VALUES (fn_next_ur_id(), 'professor', 1);

INSERT INTO bbb_user VALUES ('fardad.soleimanloo', 'Fardad', 0, 1, NULL, NULL, 1, 1, 2);
INSERT INTO bbb_user VALUES ('justin.robinson', 'Justin', 0, 1, NULL, NULL, 1, 0, 2);
INSERT INTO bbb_user VALUES ('chad.pilkey', 'Chad', 0, 1, NULL, NULL, 1, 0, 2);
INSERT INTO bbb_user VALUES ('robert.stanica', 'Robert', 0, 1, NULL, NULL, 1, 0, 2);
INSERT INTO bbb_user VALUES ('bo.li', 'Bo', 0, 1, NULL, NULL, 1, 0, 2);
INSERT INTO bbb_user VALUES ('gary.deng', 'Gary', 0, 1, NULL, NULL, 1, 0, 2);

INSERT INTO bbb_user VALUES ('jtrobins', 'Justin', 0, 1, NULL, NULL, 1, 0, 1);
INSERT INTO bbb_user VALUES ('capilkey', 'Chad', 0, 1, NULL, NULL, 1, 0, 1);
INSERT INTO bbb_user VALUES ('rwstanica', 'Robert', 0, 1, NULL, NULL, 1, 0, 1);
INSERT INTO bbb_user VALUES ('bli64', 'Bo', 0, 1, NULL, NULL, 1, 0, 1);
INSERT INTO bbb_user VALUES ('xdeng7', 'Gary', 0, 1, NULL, NULL, 1, 0, 1);

INSERT INTO department VALUES (fn_next_d_id(), 'ICT', 'Information & Communcations Technology');
INSERT INTO department VALUES (fn_next_d_id(), 'IAT', 'Information Arts & Technology');

INSERT INTO user_department VALUES ('fardad.soleimanloo', 1, 1);
INSERT INTO user_department VALUES ('jtrobins', 1, 0);
INSERT INTO user_department VALUES ('capilkey', 1, 0);

INSERT INTO subject VALUES ('PSY100', 'Introduction to Psychology');
INSERT INTO section VALUES ('PSY100', 'A', '201305', 'modpass', 'viewpass', 0, 1);
INSERT INTO section VALUES ('PSY100', 'B', '201305', 'modpass', 'viewpass', 0, 1);

INSERT INTO subject VALUES ('PSY150', 'Organizational Behaviour');
INSERT INTO section VALUES ('PSY150', 'A', '201305', 'modpass', 'viewpass', 0, 1);
INSERT INTO section VALUES ('PSY150', 'B', '201305', 'modpass', 'viewpass', 0, 1);

INSERT INTO subject VALUES ('INT222', 'Internet I - Internet Fundamentals');
INSERT INTO section VALUES ('INT222', 'A', '201305', 'modpass', 'viewpass', 0, 1);
INSERT INTO section VALUES ('INT222', 'B', '201305', 'modpass', 'viewpass', 0, 1);

INSERT INTO subject VALUES ('IPC144', 'Introduction To Programming Using C');
INSERT INTO section VALUES ('IPC144', 'A', '201305', 'modpass', 'viewpass', 0, 1);
INSERT INTO section VALUES ('IPC144', 'B', '201305', 'modpass', 'viewpass', 0, 1);

INSERT INTO subject VALUES ('OOP344', 'Object Oriented Programming II Using C++');
INSERT INTO section VALUES ('OOP344', 'A', '201305', 'modpass', 'viewpass', 0, 1);
INSERT INTO section VALUES ('OOP344', 'B', '201305', 'modpass', 'viewpass', 0, 1);

INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'A');
INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'B');

INSERT INTO student VALUES ('jtrobins', 'OOP344', 'A', 0);
INSERT INTO student VALUES ('bli64', 'OOP344', 'A', 0);
INSERT INTO student VALUES ('xdeng7', 'OOP344', 'A', 0);

INSERT INTO lecture_schedule VALUES (fn_next_ls_id(), 'OOP344', 'A', SYSDATE() + INTERVAL 1 HOUR, 50, 2, 50);
INSERT INTO lecture_schedule VALUES (fn_next_ls_id(), 'OOP344', 'B', SYSDATE() + INTERVAL 5 HOUR, 50, 2, 50);

INSERT INTO lecture VALUES (fn_next_l_id(), 1, 'OOP344', 'A', SYSDATE() + INTERVAL 1 HOUR, 50, 0, null);
INSERT INTO lecture VALUES (fn_next_l_id(), 2, 'OOP344', 'B', SYSDATE() + INTERVAL 5 HOUR, 50, 0, null);

INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 1, 1, 'OOP344', 'A');
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 2, 2, 'OOP344', 'B');

INSERT INTO guest_lecturer VALUES ('chad.pilkey', 1, 1, 'OOP344', 'A', 1);
INSERT INTO guest_lecturer VALUES ('chad.pilkey', 2, 2, 'OOP344', 'B', 1);

INSERT INTO lecture_attendance VALUES ('jtrobins', 1, 1, 'OOP344', 'A', 0);
INSERT INTO lecture_attendance VALUES ('bli64', 1, 1, 'OOP344', 'A', 0);
INSERT INTO lecture_attendance VALUES ('xdeng7', 1, 1, 'OOP344', 'A', 0);

INSERT INTO meeting_schedule VALUES (fn_next_ms_id(), 'Test Meeting 1', SYSDATE() + INTERVAL 1 HOUR, 50, 2, 50, 'gary.deng');
INSERT INTO meeting_schedule VALUES (fn_next_ms_id(), 'Test Meeting 2', SYSDATE() + INTERVAL 5 HOUR, 50, 2, 50, 'bo.li');

INSERT INTO meeting VALUES (fn_next_m_id(), 1, SYSDATE() + INTERVAL 1 HOUR, 50, 0, 'Session 1, Test Meeting 1');
INSERT INTO meeting VALUES (fn_next_m_id(), 2, SYSDATE() + INTERVAL 1 HOUR, 50, 0, 'Session 1, Test Meeting 1');

INSERT INTO meeting_attendee VALUES ('jtrobins', 1, 0);
INSERT INTO meeting_attendee VALUES ('capilkey', 1, 0);
INSERT INTO meeting_attendee VALUES ('jtrobins', 2, 0);
INSERT INTO meeting_attendee VALUES ('capilkey', 2, 0);

INSERT INTO meeting_guest VALUES ('fardad.soleimanloo', 1, 1);
INSERT INTO meeting_guest VALUES ('fardad.soleimanloo', 2, 1);

INSERT INTO meeting_presentation VALUES (1, 'Test Meeting Presentation');
INSERT INTO meeting_presentation VALUES (2, 'Test Meeting Presentation');

INSERT INTO meeting_attendance VALUES ('jtrobins', 1, 1, 0);
INSERT INTO meeting_attendance VALUES ('capilkey', 1, 1, 0);

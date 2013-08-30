
INSERT INTO bbb_user VALUES ('fardad.soleimanloo', 'Fardad', 0, 1, NULL, NULL, 1, 1, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('justin.robinson', 'Justin', 0, 1, NULL, NULL, 1, 0, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('chad.pilkey', 'Chad', 0, 1, NULL, NULL, 1, 0, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('robert.stanica', 'Robert', 0, 1, NULL, NULL, 1, 0, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('bo.li', 'Bo', 0, 1, NULL, NULL, 1, 0, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('gary.deng', 'Gary', 0, 1, NULL, NULL, 1, 0, 1, b'001', 
(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));

INSERT INTO bbb_user VALUES ('jtrobins', 'Justin', 0, 1, NULL, NULL, 1, 0, 2, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('capilkey', 'Chad', 0, 1, NULL, NULL, 1, 0, 2, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('rwstanica', 'Robert', 0, 1, NULL, NULL, 1, 0, 2, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('bli64', 'Bo', 0, 1, NULL, NULL, 1, 0, 2, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('xdeng7', 'Gary', 0, 1, NULL, NULL, 1, 0, 2, b'001', b'0011001');

INSERT INTO bbb_user VALUES ('non_ldap1', 'non_ldap1', 0, 1, NULL, NULL, 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap2', 'non_ldap2', 0, 1, NULL, NULL, 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap3', 'non_ldap3', 0, 1, NULL, NULL, 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap4', 'non_ldap4', 0, 1, NULL, NULL, 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap5', 'non_ldap5', 0, 1, NULL, NULL, 0, 0, 3, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap6', 'non_ldap6', 0, 1, NULL, NULL, 0, 0, 1, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap7', 'non_ldap7', 0, 1, NULL, NULL, 0, 0, 1, b'001', b'0011001');
INSERT INTO bbb_user VALUES ('non_ldap8', 'non_ldap8', 0, 1, NULL, NULL, 0, 0, 2, b'001', b'0011001');

INSERT INTO non_ldap_user VALUES ('non_ldap1', 'Ldap1', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap1@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap2', 'Ldap2', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap2@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap3', 'Ldap3', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap3@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap4', 'Ldap4', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap4@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap5', 'Ldap5', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap5@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap6', 'Ldap6', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap5@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap7', 'Ldap7', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap5@gmail.com', SYSDATE());
INSERT INTO non_ldap_user VALUES ('non_ldap8', 'Ldap8', 'Anon', 'a1a544e0e4a718d209755833ef6ffa85c14e2cbe7ebdd45a', 'c0b0354c1aa652e186d75525bd1f60a5f5b856e3acc230f4', 'ldap5@gmail.com', SYSDATE());

INSERT INTO department VALUES ('ICT', 'Information & Communcations Technology');
INSERT INTO department VALUES ('IAT', 'Information Arts & Technology');

INSERT INTO user_department VALUES ('fardad.soleimanloo', 'ICT', 1);
INSERT INTO user_department VALUES ('jtrobins', 'ICT', 0);
INSERT INTO user_department VALUES ('capilkey', 'ICT', 0);
INSERT INTO user_department VALUES ('rwstanica', 'ICT', 0);
INSERT INTO user_department VALUES ('bli64', 'ICT', 0);
INSERT INTO user_department VALUES ('xdeng7', 'ICT', 0);

INSERT INTO course VALUES ('PSY100', 'Introduction to Psychology');
INSERT INTO section VALUES ('PSY100', 'A', '201305', 'IAT');
INSERT INTO section VALUES ('PSY100', 'B', '201305', 'IAT');

INSERT INTO course VALUES ('PSY150', 'Organizational Behaviour');
INSERT INTO section VALUES ('PSY150', 'A', '201305', 'IAT');
INSERT INTO section VALUES ('PSY150', 'B', '201305', 'IAT');

INSERT INTO course VALUES ('INT222', 'Internet I - Internet Fundamentals');
INSERT INTO section VALUES ('INT222', 'A', '201305', 'ICT');
INSERT INTO section VALUES ('INT222', 'B', '201305', 'ICT');

INSERT INTO course VALUES ('IPC144', 'Introduction To Programming Using C');
INSERT INTO section VALUES ('IPC144', 'A', '201305', 'ICT');
INSERT INTO section VALUES ('IPC144', 'B', '201305', 'ICT');

INSERT INTO course VALUES ('OOP344', 'Object Oriented Programming II Using C++');
INSERT INTO section VALUES ('OOP344', 'A', '201305', 'ICT');
INSERT INTO section VALUES ('OOP344', 'B', '201305', 'ICT');

INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'A', '201305', b'0011110');
INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'B', '201305', b'0011110');
INSERT INTO professor VALUES ('bo.li', 'INT222', 'A', '201305', b'0011110');
INSERT INTO professor VALUES ('bo.li', 'INT222', 'B', '201305', b'0011110');
INSERT INTO professor VALUES ('chad.pilkey', 'PSY100', 'A', '201305', b'0011110');
INSERT INTO professor VALUES ('chad.pilkey', 'PSY100', 'B', '201305', b'0011110');
INSERT INTO professor VALUES ('justin.robinson', 'IPC144', 'A', '201305', b'0011110');
INSERT INTO professor VALUES ('justin.robinson', 'IPC144', 'B', '201305', b'0011110');
INSERT INTO professor VALUES ('non_ldap2', 'PSY150', 'A', '201305', b'0011110');
INSERT INTO professor VALUES ('non_ldap2', 'PSY150', 'B', '201305', b'0011110');

INSERT INTO student VALUES ('jtrobins', 'OOP344', 'A', '201305', 0);
INSERT INTO student VALUES ('bli64', 'OOP344', 'A', '201305', 0);
INSERT INTO student VALUES ('xdeng7', 'OOP344', 'A', '201305', 0);
INSERT INTO student VALUES ('rwstanica', 'OOP344', 'B', '201305', 0);
INSERT INTO student VALUES ('non_ldap1', 'OOP344', 'B', '201305', 0);
INSERT INTO student VALUES ('non_ldap2', 'OOP344', 'B', '201305', 0);

CALL sp_create_ls('OOP344', 'A', '201305', '2013-07-01 10:00:00', '2;1;5;1', 50, 'OOP344A');
CALL sp_create_ls('OOP344', 'B', '201305', '2013-09-03 10:00:00', '2;2;2013-10-01;6', 50, 'OOP344B');
CALL sp_create_ls('IPC144', 'A', '201305', '2013-08-03 10:00:00', '1', 50, 'IPC144');
CALL sp_create_ls('IPC144', 'B', '201305', '2013-08-03 10:00:00', '3;1;10;2;0011000', 50, 'IPC144');
CALL sp_create_ls('PSY100', 'A', '201305', '2013-08-03 10:00:00', '3;2;10;2;0100000', 50, 'PSY100');
CALL sp_create_ls('PSY100', 'B', '201305', '2013-08-03 10:00:00', '3;3;2013-11-11;3;0100001', 50, 'PSY100');
CALL sp_create_ls('PSY150', 'A', '201305', '2013-08-03 10:00:00', '4;1;7;1;31', 50, 'PSY150');
CALL sp_create_ls('PSY150', 'B', '201305', '2013-08-23 10:00:00', '4;1;7;2;5', 50, 'PSY150');
CALL sp_create_ls('INT222', 'A', '201305', '2013-08-05 10:00:00', '4;2;7;1;1', 50, 'PSY150');
CALL sp_create_ls('INT222', 'B', '201305', '2013-08-23 10:00:00', '4;2;7;2;2', 50, 'PSY150');

INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 1, 1);
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 1, 2);
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 1, 3);
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 2, 1);
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 2, 2);
INSERT INTO lecture_presentation VALUES ('Bit-Wise Operations', 2, 3);

INSERT INTO guest_lecturer VALUES ('chad.pilkey', 1, 1, 1);
INSERT INTO guest_lecturer VALUES ('chad.pilkey', 2, 1, 1);
INSERT INTO guest_lecturer VALUES ('justin.robinson', 1, 2, 1);
INSERT INTO guest_lecturer VALUES ('justin.robinson', 2, 2, 1);

INSERT INTO lecture_attendance VALUES ('jtrobins', 1, 1, 0);
INSERT INTO lecture_attendance VALUES ('bli64', 1, 1, 0);
INSERT INTO lecture_attendance VALUES ('xdeng7', 1, 1, 0);
INSERT INTO lecture_attendance VALUES ('rwstanica', 2, 1, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap1', 2, 1, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap2', 2, 1, 0);
INSERT INTO lecture_attendance VALUES ('jtrobins', 1, 2, 0);
INSERT INTO lecture_attendance VALUES ('bli64', 1, 2, 0);
INSERT INTO lecture_attendance VALUES ('xdeng7', 1, 2, 0);
INSERT INTO lecture_attendance VALUES ('rwstanica', 2, 2, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap1', 2, 2, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap2', 2, 2, 0);
INSERT INTO lecture_attendance VALUES ('jtrobins', 1, 3, 0);
INSERT INTO lecture_attendance VALUES ('bli64', 1, 3, 0);
INSERT INTO lecture_attendance VALUES ('xdeng7', 1, 3, 0);
INSERT INTO lecture_attendance VALUES ('rwstanica', 2, 3, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap1', 2, 3, 0);
INSERT INTO lecture_attendance VALUES ('non_ldap2', 2, 3, 0);

CALL sp_create_ms('Test Meeting Schedule 1', '2013-07-01 10:00:00', '2;1;5;2', 50, 'Test Meeting 1 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 2', '2013-07-22 13:00:00', '2;2;2013-10-01;7', 50, 'Test Meeting 2 description', 'bli64');
CALL sp_create_ms('Test Meeting Schedule 3', '2013-07-01 10:00:00', '1', 50, 'Test', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 4', '2013-08-01 10:00:00', '3;1;6;1;0111110', 50, 'Test Meeting 4 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 5', '2013-08-01 10:00:00', '3;2;6;2;0110010', 50, 'Test Meeting 5 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 6', '2013-08-01 10:00:00', '3;3;2013-11-11;3;0110010', 50, 'Test Meeting 5 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 7', '2013-02-01 10:00:00', '4;1;7;1;31', 50, 'Test Meeting 7 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 8', '2013-01-30 10:00:00', '4;1;5;1;30', 50, 'Test Meeting 8 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 9', '2013-12-31 10:00:00', '4;1;5;3;30', 50, 'Test Meeting 9 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 10', '2013-12-31 10:00:00', '4;2;5;1;3', 50, 'Test Meeting 10 description', 'bo.li');
CALL sp_create_ms('Test Meeting Schedule 11', '2013-12-31 10:00:00', '4;2;5;3;7', 50, 'Test Meeting 11 description', 'bo.li');


INSERT INTO meeting_attendee VALUES ('jtrobins', 1, 0);
INSERT INTO meeting_attendee VALUES ('capilkey', 1, 0);
INSERT INTO meeting_attendee VALUES ('non_ldap2', 1, 1);
INSERT INTO meeting_attendee VALUES ('jtrobins', 2, 0);
INSERT INTO meeting_attendee VALUES ('capilkey', 2, 0);
INSERT INTO meeting_attendee VALUES ('non_ldap3', 2, 1);

INSERT INTO meeting_guest VALUES ('fardad.soleimanloo', 1, 1, 1);
INSERT INTO meeting_guest VALUES ('fardad.soleimanloo', 2, 1, 1);

INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 1-1-1', 1, 1);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 1-1-2', 1, 1);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 1-2-1', 1, 2);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 1-2-2', 1, 2);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 2-1-1', 2, 1);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 2-1-2', 2, 1);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 2-2-1', 2, 2);
INSERT INTO meeting_presentation VALUES ('Test Meeting Presentation 2-2-2', 2, 2);

INSERT INTO meeting_attendance VALUES ('jtrobins', 1, 1, 0);
INSERT INTO meeting_attendance VALUES ('capilkey', 1, 1, 0);
INSERT INTO meeting_attendance VALUES ('bli64', 1, 1, 1);
INSERT INTO meeting_attendance VALUES ('jtrobins', 1, 2, 0);
INSERT INTO meeting_attendance VALUES ('capilkey', 1, 2, 0);
INSERT INTO meeting_attendance VALUES ('bli64', 1, 2, 1);
INSERT INTO meeting_attendance VALUES ('jtrobins', 2, 1, 0);
INSERT INTO meeting_attendance VALUES ('capilkey', 2, 1, 0);
INSERT INTO meeting_attendance VALUES ('jtrobins', 2, 2, 0);
INSERT INTO meeting_attendance VALUES ('capilkey', 2, 2, 0);


INSERT INTO bbb_user VALUES ('test4', 'test4', 0, 1, 'comment', NULL, 1, 0, 1, (SELECT key_value FROM bbb_admin WHERE key_name='default_user'), (SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'));
INSERT INTO bbb_user VALUES ('nutest1', 'nutest1', 0, 1, 'comment', NULL, 0, 0, 3, (SELECT key_value FROM bbb_admin WHERE key_name='default_user'), (SELECT key_value FROM bbb_admin WHERE key_name='default_meeting')); 
INSERT INTO non_ldap_user VALUES ('nutest1', 'some', 'name', 'xsdwe', 'sdsd', 'nu_email@gmail.com', SYSDATE());

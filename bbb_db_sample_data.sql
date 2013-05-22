
INSERT INTO user_role (ur_id, ur_name) VALUES (fn_next_ur_id(), 'student');
INSERT INTO user_role (ur_id, ur_name) VALUES (fn_next_ur_id(), 'professor');

INSERT INTO bbb_user (u_id, ur_id) VALUES ('fardad.soleimanloo', 2);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('justin.robinson', 2);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('chad.pilkey', 2);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('robert.stanica', 2);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('bo.li', 2);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('gary.deng', 2);

INSERT INTO bbb_user (u_id, ur_id) VALUES ('jtrobins', 1);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('capilkey', 1);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('rwstanica', 1);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('bli64', 1);
INSERT INTO bbb_user (u_id, ur_id) VALUES ('xdeng7', 1);

INSERT INTO subject VALUES ('PSY100', 'Introduction to Psychology');
INSERT INTO section(sub_id, sc_id) VALUES ('PSY100', 'A');
INSERT INTO section(sub_id, sc_id) VALUES ('PSY100', 'B');

INSERT INTO subject VALUES ('PSY150', 'Organizational Behaviour');
INSERT INTO section(sub_id, sc_id) VALUES ('PSY150', 'A');
INSERT INTO section(sub_id, sc_id) VALUES ('PSY150', 'B');

INSERT INTO subject VALUES ('INT222', 'Internet I - Internet Fundamentals');
INSERT INTO section(sub_id, sc_id) VALUES ('INT222', 'A');
INSERT INTO section(sub_id, sc_id) VALUES ('INT222', 'B');

INSERT INTO subject VALUES ('IPC144', 'Introduction To Programming Using C');
INSERT INTO section(sub_id, sc_id) VALUES ('IPC144', 'A');
INSERT INTO section(sub_id, sc_id) VALUES ('IPC144', 'B');

INSERT INTO subject VALUES ('OOP344', 'Object Oriented Programming II Using C++');
INSERT INTO section(sub_id, sc_id) VALUES ('OOP344', 'A');
INSERT INTO section(sub_id, sc_id) VALUES ('OOP344', 'B');

INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'A');
INSERT INTO professor VALUES ('fardad.soleimanloo', 'OOP344', 'B');


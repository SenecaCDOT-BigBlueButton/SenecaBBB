
#INSERT INTO bbb_admin VALUES (0, 0);
#INSERT INTO user_role VALUES (null, 'AVG', 2);
INSERT INTO bbb_user VALUES ('abd', 1, 1, 'ddfsdf', '1000-01-01 00:00:00', 1, 1, '1');
DELETE FROM bbb_user WHERE u_id='abd';
DELETE FROM user_role WHERE ur_id=1; 
SenecaBBB
=========

Seneca BigBlueButton Integration Project


Setting up DB on Ubuntu 12.04
-----------------------------

1) Run these commands to install mysql (note the password you set when installing mysql server)
- sudo apt-get install mysql-server
- sudo apt-get install mysql-client
- sudo apt-get install libmysql-java
	
2) Edit your mysql configuration file
- sudo gedit /etc/mysql/my.cnf
- port = 3309 (change all instances of port)
- bind-address = local VM ip

3) Connect to mysql-server (use the password you set when installing mysql server)
- mysql -u root -p

4) Create a user for remote access to DB and grant privileges
- create user 'senecaBBB'@'%' identified by 'db';
- grant all on db.* to 'senecaBBB'@'%' IDENTIFIED by 'db';

5) In NetBeans, click on the Services tab then right click Databases -> New Connection 
   and choose MySQL
   - Host: 127.0.0.1
   - Port: 3309
   - Username: senecaBBB
   - Password: db

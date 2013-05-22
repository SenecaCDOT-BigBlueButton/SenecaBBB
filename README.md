SenecaBBB
=========

Seneca BigBlueButton Integration Project


# Setting up DB on Ubuntu 12.04

1) Run these commands to install mysql (note the password you set when installing mysql server)
```
sudo apt-get install mysql-server
sudo apt-get install mysql-client
sudo apt-get install libmysql-java
```
	
2) Edit your mysql configuration file
```
sudo gedit /etc/mysql/my.cnf
```
- port = 3309 (change all instances of port)
- bind-address = local VM ip


3) Restart the mysql service
```
sudo service mysql restart
```

4) Download the script file (bbb_db_auto.sql) and run it 
```
mysql -u root -p db < bbb_db_manual.sql
mysql -u root -p db < bbb_db_fn_nextval.sql
mysql -u root -p db < bbb_db_sample_data.sql
```

5) Connect to mysql-server (use the password you set when installing mysql server)
```
mysql -u root -p
```

6) Create a user for remote access to DB and grant privileges
```
create user 'senecaBBB'@'%' identified by 'db';
grant all on db.* to 'senecaBBB'@'%' IDENTIFIED by 'db';
```

7) In NetBeans, click on the Services tab then right click Databases -> New Connection 
   and choose MySQL
   - Host: 127.0.0.1 //ifnot working, use your VM IP
   - Port: 3309
   - Username: senecaBBB
   - Password: db

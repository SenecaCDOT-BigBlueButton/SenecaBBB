# SenecaBBB

Seneca BigBlueButton Integration Project

## 
## Setting up Database on Ubuntu 12.04

* Run these commands to install mysql (note the password you set when installing mysql server)
```
    sudo apt-get install mysql-server
    sudo apt-get install mysql-client
    sudo apt-get install libmysql-java
```
    
* Edit your mysql configuration file
```
    sudo gedit /etc/mysql/my.cnf
    port = 3309 (change all instances of port)
    bind-address = local VM ip
```

* Set mysql timezone to UTC, add default_time_zone. We store event scheduled date&time in UTC in order to solve global timezone issue

```
    [mysqld]
    **other variables**
    default_time_zone='+00:00'
```
* Double check mysql timezone setting:
```
    mysql> SELECT @@global.time_zone,@@session.time_zone;

		|--------------------|---------------------|
		| @@global.time_zone | @@session.time_zone |
		|--------------------|---------------------|
		| +00:00             | +00:00              |
		|--------------------|---------------------|
```

* Populate mysql.time_zone_name table to mysql server, if the following query return empty,follow instructions to populate that table: http://dev.mysql.com/doc/refman/5.5/en/time-zone-support.html

``` 
    select * from mysql.time_zone_name;
```

* Restart the mysql service

```
    sudo service mysql restart
```

* Connect to mysql-server (use the password you set when installing mysql server)

```
    mysql -u root -p
```
* Create the database 'db' then exit
```
    create database db;
```

* Download the MySQL script files and run them (from terminal)

```
    mysql -u root -p db < bbb_db_creation.sql
    mysql -u root -p db < bbb_db_init.sql
    mysql -u root -p db < bbb_db_sampleData.sql
```

* Connect to mysql-server again

```
    mysql -u root -p
```

* Create a user for remote access to DB and grant privileges

```
    create user 'senecaBBB'@'%' identified by 'db';
    grant all on db.* to 'senecaBBB'@'%' IDENTIFIED by 'db';
```
* To connect to database,bigbluebutton server, and email server, please copy the config.properties.template file in directory:
```
    web-app/WebContent/WEB-INF/classes/config/
```

* Rename it to config.properties. Please also fill in the missing information in the file.

* To customize 404 error page, please add the following lines to web.xml file in tomcat7 server
```
    <error-page>
        <error-code>404</error-code>
        <location>/page_not_found.jsp</location>
    </error-page>  
```
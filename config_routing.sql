0.5 Create user monitoring and apps on db master 
CREATE USER  'monitor'@'[YOUR IP PROXYSQL]' IDENTIFIED BY 'monitor';
GRANT USAGE,REPLICATION CLIENT on *.* TO 'monitor'@'[YOUR IP PROXYSQL]'';

CREATE USER 'userapps'@'[YOUR IP PROXYSQL]' IDENTIFIED BY 'abcd123';
GRANT USAGE, SELECT, INSERT, UPDATE, DELETE ON dbapps.* TO 'userapps'@'[YOUR IP PROXYSQL]' IDENTIFIED BY 'abcd123';

-- login into proxysql admin
1. Insert hostgroup
   INSERT INTO mysql_replication_hostgroups (writer_hostgroup,reader_hostgroup,comment) VALUES (0,1,'db-proxysql');

2. Define db server
   -- master
       INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (0,'10.0.0.1',3306);
   -- slave
       INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'10.0.0.2',3306);
       INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'10.0.0.3',3306);

LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

2.5 setup weight point (optional)
   UPDATE mysql_servers SET weight=200 WHERE hostgroup_id=1 AND hostname='10.0.0.3';
   SELECT hostgroup_id,hostname,port,status,weight FROM mysql_servers;

3. config monitor user
   UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_password';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

4. config app user
   INSERT INTO mysql_users(username,password,default_hostgroup,max_connections) VALUES ('userapps','abcd123',2000);
   SELECT username,password,active,default_hostgroup,default_schema,max_connections FROM mysql_users;
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;


5. Configure monitoring
   UPDATE global_variables SET variable_value = 2000 WHERE variable_name IN ('mysql-monitor_connect_interval','mysql-monitor_ping_interval','mysql-monitor_read_only_interval');
   UPDATE global_variables SET variable_value = 1000 where variable_name = 'mysql-monitor_connect_timeout';
   UPDATE global_variables SET variable_value = 500 where variable_name = 'mysql-monitor_ping_timeout';
   UPDATE mysql_servers SET max_replication_lag = 30;

LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

6. Configure Query Rules
   INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^SELECT.*', 1, 0);
   INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^INSERT.*', 0, 0);
   INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^UPDATE.*', 0, 0);
   INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^DELETE.*', 0, 0);
   INSERT INTO mysql_query_rules (active, match_digest, destination_hostgroup, apply) VALUES (1, '^SELECT.*FOR UPDATE', 0, 1);

LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;

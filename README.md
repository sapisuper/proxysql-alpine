# proxysql-alpine
Build docker proxysql with base image from alpine

# Efficient MySQL workload management
ProxySQL helps you squeeze the last drop of performance out of your MySQL cluster, without controlling the applications that generate the queries.

# How to build
1. pull this repo

2. build this dockerfile
   docker build -t proxysql-alpine:1.0 .

3. Start your container
   docker run -d --name proxysql --restart always -p 6033:6033 -p 6032:6032 proxysql-alpine:1.0

4. Connect to ProxySQL administration interface
    $ mysql -u proxysqladmin -pproxysqladmin -h 0.0.0.0 -P6032 --prompt='Admin> '
      mysql: [Warning] Using a password on the command line interface can be insecure.
      Welcome to the MySQL monitor.  Commands end with ; or \g.
      Your MySQL connection id is 1
      Server version: 5.5.30 (ProxySQL Admin Module)

      Copyright (c) 2009-2018 Percona LLC and/or its affiliates
      Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

      Oracle is a registered trademark of Oracle Corporation and/or its
      affiliates. Other names may be trademarks of their respective
      owners.

      Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

      Admin> show databases;
      +-----+---------------+-------------------------------------+
      | seq | name          | file                                |
      +-----+---------------+-------------------------------------+
      | 0   | main          |                                     |
      | 2   | disk          | /var/lib/proxysql/proxysql.db       |
      | 3   | stats         |                                     |
      | 4   | monitor       |                                     |
      | 5   | stats_history | /var/lib/proxysql/proxysql_stats.db |
      +-----+---------------+-------------------------------------+
      5 rows in set (0.00 sec)

      Admin> 

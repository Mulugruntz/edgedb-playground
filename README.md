# edgedb-playground
Playground with EdgeDB + Docker

## Problem
A table creation that was committed seems to have disappeared after another table creation.


## How to reproduce:

### Prerequisites
* docker (installed: `Docker version 19.03.5, build 633a0ea
`)
* docker-compose (installed: `docker-compose version 1.25.4, build 8d51620a
`)

### Steps
```
git clone https://github.com/Mulugruntz/edgedb-playground.git
cd edgedb-playground
docker-compose up --build
```

## What is happening
* A connection is opened
* For each of the following, we open a new transaction with the same connection.
    * Table A gets created
    * Check: table A exists
    * Table B gets created
    * Check: table B exists
    * Check: table A does not exist anymore???
    
## Output
```
Successfully built 3fb30607c045
Successfully tagged edgedb-playground_playground:latest
Creating edgedb-pg ... done
Creating playground ... done
Attaching to edgedb-pg, playground
edgedb-pg     | Bootstrapping EdgeDB instance...
playground    | 2020/02/20 15:58:40 Waiting for: tcp://edgedb:5656
playground    | 2020/02/20 15:58:40 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
playground    | 2020/02/20 15:58:50 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
playground    | 2020/02/20 15:59:00 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
playground    | 2020/02/20 15:59:10 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
playground    | 2020/02/20 15:59:20 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
edgedb-pg     | CONFIGURE SYSTEM
edgedb-pg     | CONFIGURE SYSTEM
playground    | 2020/02/20 15:59:30 Problem with dial: dial tcp 172.23.0.2:5656: connect: connection refused. Sleeping 10s
edgedb-pg     | INFO 1 2020-02-20 15:59:32,700 edb.server: EdgeDB server (1.0-alpha.2+g16f75ece5.d20200122) starting.
edgedb-pg     | INFO 1 2020-02-20 15:59:36,930 edb.server: Serving on 0.0.0.0:5656
edgedb-pg     | INFO 1 2020-02-20 15:59:36,930 edb.server: Serving on /run/edgedb/.s.EDGEDB.5656
edgedb-pg     | INFO 1 2020-02-20 15:59:36,932 edb.server: Serving admin on /run/edgedb/.s.EDGEDB.admin.5656
playground    | 2020/02/20 15:59:40 Connected to tcp://edgedb:5656
playground    | Creating a Pipfile for this project…
playground    | Table A created.
playground    | Set{Object{name := 'default::A'}}
playground    | Table B created.
playground    | Set{Object{name := 'default::B'}}
playground    | Set{}
playground exited with code 0
```
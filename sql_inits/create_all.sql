DROP DATABASE IF EXISTS tjournal;
CREATE DATABASE tjournal;




CREATE TABLE tjournal.`EXCP`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`exception` String,
`descr` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`EXCPCNTX`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`clientcomputername` String,
`servercomputername` String,
`username` String,
`connectstring` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SCALL`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`clientid` String,
`interface` String,
`iname` String,
`method` String,
`callid` String,
`mname` String,
`dstclientid` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CONN`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`txt` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CALL`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`clientid` String,
`callwait` Int32,
`first` String,
`interface` String,
`iname` String,
`method` String,
`callid` String,
`mname` String,
`memory` Int32,
`memorypeak` Int32,
`inbytes` Int32,
`outbytes` Int32,
`cputime` Int32,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SDBL`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`clientid` String,
`applicationname` String,
`computername` String,
`connectid` String,
`sessionid` String,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`trans` Int32,
`sdbl` String,
`rows` Int32,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBMSSQL`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`clientid` String,
`applicationname` String,
`computername` String,
`connectid` String,
`sessionid` String,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`trans` Int32,
`dbpid` String,
`sql` String,
`rows` Int32,
`rowsaffected` Int32,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TLOCK`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`clientid` String,
`applicationname` String,
`computername` String,
`connectid` String,
`sessionid` String,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`regions` String,
`locks` String,
`waitconnections` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`QERR`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`clientid` String,
`applicationname` String,
`computername` String,
`connectid` String,
`sessionid` String,
`usr` String,
`appid` String,
`descr` String,
`query` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);





-- ALL EVENTS = ['ADMIN', 'CONN', 'FTEXTUpd', 'CLSTR', 'ADDIN', 'TLOCK', 'VRSREQUEST', 'LIC', 'QERR', 'ATTN', 'SCOM', 'CALL', 'SRVC', 'EXCP', 'HASP', 'DBMSSQLCONN', 'DBMSSQL', 'EXCPCNTX', 'SCALL', 'Context', 'SDBL', 'EVENTLOG', 'VRSRESPONSE', 'SDGC', 'SESN', 'FTS']

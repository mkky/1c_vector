DROP DATABASE IF EXISTS tjournal;
CREATE DATABASE tjournal;




CREATE TABLE tjournal.`EXCP`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`exception` String,
`descr` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`EXCPCNTX`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`clientcomputername` String,
`servercomputername` String,
`username` String,
`connectstring` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SCALL`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
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
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CONN`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`txt` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CALL`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`clientid` String,
`callwait` String,
`first` String,
`interface` String,
`iname` String,
`method` String,
`callid` String,
`mname` String,
`memory` String,
`memorypeak` String,
`inbytes` String,
`outbytes` String,
`cputime` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SDBL`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
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
`trans` String,
`sdbl` String,
`rows` String,
`context` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBMSSQL`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
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
`trans` String,
`dbpid` String,
`sql` String,
`rows` String,
`rowsaffected` String,
`context` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TLOCK`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
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
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`QERR`(
`host` String,
`ts` DateTime64(6,'UTC'),
`duration` String,
`name` String,
`depth` String,
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
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);





-- ALL EVENTS = ['SESN', 'FTS', 'EVENTLOG', 'ADDIN', 'SCOM', 'CALL', 'DBMSSQL', 'SRVC', 'CLSTR', 'SDBL', 'CONN', 'EXCP', 'SDGC', 'LIC', 'VRSREQUEST', 'EXCPCNTX', 'QERR', 'VRSRESPONSE', 'SCALL', 'DBMSSQLCONN', 'ATTN', 'Context', 'ADMIN', 'HASP', 'TLOCK', 'FTEXTUpd']

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


CREATE TABLE tjournal.`ATTN`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`descr` String,
`agenturl` String,
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


CREATE TABLE tjournal.`ADMIN`(
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
`func` String,
`clusterid` String,
`cluster` String,
`administrator` String,
`result` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CLSTR`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`event` String,
`rmngrurl` String,
`servicename` String,
`clusterid` String,
`targetcall` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SESN`(
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
`func` String,
`ib` String,
`appl` String,
`nmb` String,
`id` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SRVC`(
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
`descr` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`FTEXTUpd`(
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
`func` String,
`state` String,
`time` String,
`avmem` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`FTS`(
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
`component` String,
`line` String,
`file` String,
`descr` String,
`infobaseid` String,
`func` String,
`host` String,
`context` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`EVENTLOG`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`func` String,
`filename` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SDGC`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`instanceid` String,
`datapath` String,
`usedsize` String,
`filessize` String,
`method` String,
`copybytes` String,
`lockduration` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`HASP`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`txt` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`LIC`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`func` String,
`res` String,
`txt` String,
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


CREATE TABLE tjournal.`VRSREQUEST`(
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
`method` String,
`uri` String,
`headers` String,
`body` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`VRSRESPONSE`(
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
`status` String,
`phrase` String,
`headers` String,
`body` String,
`host` String,
`context` String,
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


CREATE TABLE tjournal.`SCOM`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` String,
`clientid` String,
`func` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBMSSQLCONN`(
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
`dbms` String,
`database` String,
`hresultmsoledbsql19` String,
`hresultmsoledbsql` String,
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


CREATE TABLE tjournal.`ADDIN`(
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
`func` String,
`location` String,
`classes` String,
`connectiontype` String,
`result` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBPOSTGRS`(
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
`rowsaffected` Int32,
`result` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TTIMEOUT`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`level` String,
`process` String,
`processid` String,
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
`rowsaffected` Int32,
`result` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`TDEADLOCK`(
`ts` DateTime64(6,'UTC'),
`duration` Int32,
`name` String,
`level` String,
`process` String,
`processid` String,
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
`rowsaffected` Int32,
`result` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);





-- ALL EVENTS = ['FTS', 'SDBL', 'EXCP', 'LIC', 'FTEXTUpd', 'SCALL', 'CLSTR', 'QERR', 'SRVC', 'CALL', 'VRSRESPONSE', 'CONN', 'EVENTLOG', 'DBMSSQL', 'SCOM', 'EXCPCNTX', 'Context', 'SESN', 'DBPOSTGRS', 'ADMIN', 'TTIMEOUT', 'VRSREQUEST', 'HASP', 'TLOCK', 'ATTN', 'ADDIN', 'SDGC', 'DBMSSQLCONN']

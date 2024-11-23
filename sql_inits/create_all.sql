DROP DATABASE IF EXISTS tjournal;
CREATE DATABASE tjournal;






CREATE TABLE tjournal.`EXCP`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`ts` DateTime64(6,'Europe/Moscow'),
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
`ts` DateTime64(6,'Europe/Moscow'),
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
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`txt` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`ATTN`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`descr` String,
`agenturl` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`CALL`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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




CREATE TABLE tjournal.`ADMIN`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`func` String,
`clusterid` String,
`cluster` String,
`administrator` String,
`result` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`CLSTR`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`event` String,
`rmngrurl` String,
`servicename` String,
`clusterid` String,
`targetcall` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`Context`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`context` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`SESN`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`func` String,
`ib` String,
`appl` String,
`nmb` String,
`id` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`SRVC`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`descr` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`FTEXTUpd`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`func` String,
`state` String,
`time` String,
`avmem` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`FTS`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`component` String,
`line` String,
`file` String,
`descr` String,
`infobaseid` String,
`func` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`EVENTLOG`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`func` String,
`filename` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`SDGC`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
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
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`HASP`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`txt` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`LIC`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`processname` String,
`osthread` String,
`func` String,
`res` String,
`txt` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`SDBL`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`ts` DateTime64(6,'Europe/Moscow'),
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




CREATE TABLE tjournal.`VRSREQUEST`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`method` String,
`uri` String,
`headers` String,
`body` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`VRSRESPONSE`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`status` String,
`phrase` String,
`headers` String,
`body` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`TLOCK`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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




CREATE TABLE tjournal.`SCOM`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
`duration` String,
`name` String,
`depth` String,
`level` String,
`process` String,
`osthread` String,
`clientid` String,
`func` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`DBMSSQLCONN`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`dbms` String,
`database` String,
`hresultmsoledbsql19` String,
`hresultmsoledbsql` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);




CREATE TABLE tjournal.`QERR`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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




CREATE TABLE tjournal.`ADDIN`(
`host` String,
`ts` DateTime64(6,'Europe/Moscow'),
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
`func` String,
`location` String,
`classes` String,
`connectiontype` String,
`result` String,
`context` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);





-- ALL TABLES = ['LIC', 'QERR', 'TLOCK', 'DBMSSQL', 'EXCP', 'SCOM', 'ATTN', 'CALL', 'SCALL', 'VRSRESPONSE', 'EVENTLOG', 'EXCPCNTX', 'SRVC', 'SDGC', 'FTEXTUpd', 'HASP', 'SESN', 'CONN', 'ADDIN', 'SDBL', 'VRSREQUEST', 'ADMIN', 'DBMSSQLCONN', 'FTS', 'Context', 'CLSTR']

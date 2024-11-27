DROP DATABASE IF EXISTS tjournal;
CREATE DATABASE tjournal;




CREATE TABLE tjournal.LST(
  uid String,
  db_name_1c String,
  comments String,
  db_type String,
  db_addr String,
  db_name_subd String,
  db_user String,
  is_license String,
  server String,
  block_rz String,
  file String,
  host String,
) ENGINE = ReplacingMergeTree() ORDER BY uid;


CREATE TABLE tjournal.`SCALL`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`interface` String,
`iname` String,
`method` String,
`callid` Int32,
`mname` String,
`dstclientid` String,
`processname` String,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`context` String,
`tmpconnectid` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`ATTN`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`descr` String,
`url` String,
`agenturl` String,
`processid` String,
`pid` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CONN`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`txt` String,
`clientid` Int32,
`protected` String,
`descr` String,
`computername` String,
`applicationname` String,
`connectid` Int32,
`calls` String,
`processname` String,
`usr` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CALL`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`callwait` Int32,
`first` String,
`interface` String,
`iname` String,
`method` String,
`callid` Int32,
`mname` String,
`memory` Int32,
`memorypeak` Int32,
`inbytes` Int32,
`outbytes` Int32,
`cputime` Int32,
`retexcp` String,
`connectid` Int32,
`usr` String,
`sessionid` Int32,
`context` String,
`func` String,
`module` String,
`appid` String,
`form` String,
`formitem` String,
`searchstring` String,
`report` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`ADMIN`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`func` String,
`administrator` String,
`result` String,
`clusterid` String,
`cluster` String,
`serverid` String,
`ref` String,
`infobaseid` String,
`seanceid` String,
`val` String,
`connectionid` String,
`mode` String,
`host` String,
`connection` String,
`connectid` Int32,
`schjobdn` String,
`descr` String,
`dbms` String,
`dbsrvr` String,
`db` String,
`dbuid` String,
`licdstr` String,
`esmurl` String,
`esmen` String,
`ibsepr` String,
`smsepr` String,
`disstt` String,
`cud` String,
`msjrp` String,
`msjss` String,
`sessionid` Int32,
`usr` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`EXCP`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`descr` String,
`processname` String,
`applicationname` String,
`computername` String,
`exception` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`dbms` String,
`database` String,
`dbpid` Int32,
`appid` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`CLSTR`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`event` String,
`data` String,
`ref` String,
`srcaddr` String,
`srcid` String,
`srcpid` String,
`applicationext` String,
`request` String,
`dstaddr` String,
`dstid` String,
`dstpid` String,
`rmngrurl` String,
`servicename` String,
`sessionid` Int32,
`targetcall` String,
`processname` String,
`connectid` Int32,
`extdata` String,
`infobase` String,
`usr` String,
`context` String,
`distribdata` String,
`clusterid` String,
`message` String,
`dbms` String,
`database` String,
`appid` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SESN`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`func` String,
`ib` String,
`appl` String,
`nmb` String,
`id` String,
`processname` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`HASP`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`txt` String,
`processname` String,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SRVC`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`descr` String,
`processname` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBPOSTGRS`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`dbms` String,
`database` String,
`trans` Int32,
`dbpid` Int32,
`sql` String,
`rowsaffected` Int32,
`result` String,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`context` String,
`func` String,
`prm` String,
`tablename` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`VRSREQUEST`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`method` String,
`uri` String,
`headers` String,
`body` String,
`sessionid` Int32,
`usr` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SDBL`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`trans` Int32,
`sdbl` String,
`rows` Int32,
`context` String,
`func` String,
`sbst` String,
`tablename` String,
`tmpconnectid` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`VRSRESPONSE`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`status` String,
`phrase` String,
`headers` String,
`body` String,
`sessionid` Int32,
`usr` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TLOCK`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`regions` String,
`locks` String,
`waitconnections` Int32,
`context` String,
`txt` String,
`alreadylocked` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TDEADLOCK`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`regions` String,
`locks` String,
`waitconnections` Int32,
`context` String,
`txt` String,
`alreadylocked` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`LIC`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`func` String,
`res` String,
`txt` String,
`connectid` Int32,
`sessionid` Int32,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SCOM`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`func` String,
`processname` String,
`applicationname` String,
`computername` String,
`connectid` Int32,
`srcprocessname` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`EXCPCNTX`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`clientcomputername` String,
`servercomputername` String,
`username` String,
`connectstring` String,
`srcname` String,
`process` String,
`osthread` Int32,
`clientid` Int32,
`interface` String,
`iname` String,
`method` String,
`callid` Int32,
`mname` String,
`processname` String,
`srcprocessname` String,
`callwait` Int32,
`first` String,
`func` String,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`dbms` String,
`database` String,
`trans` Int32,
`dbpid` Int32,
`sql` String,
`rows` Int32,
`rowsaffected` Int32,
`sdbl` String,
`form` String,
`formitem` String,
`searchstring` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`FTEXTUpd`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`func` String,
`state` String,
`time` String,
`avmem` String,
`durationus` String,
`mindataid` String,
`memoryused` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`context` String,
`backgroundjobcreated` String,
`totaljobscount` String,
`failedjobscount` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`FTS`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
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
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`func` String,
`filename` String,
`host` String,
`context` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`SDGC`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
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


CREATE TABLE tjournal.`DBMSSQL`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`trans` Int32,
`dbpid` Int32,
`sql` String,
`rows` Int32,
`rowsaffected` Int32,
`context` String,
`func` String,
`prm` String,
`tablename` String,
`tmpconnectid` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`DBMSSQLCONN`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
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
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
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
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`depth` Int32,
`level` String,
`process` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`func` String,
`location` String,
`classes` String,
`connectiontype` String,
`result` String,
`context` String,
`type` String,
`methodname` String,
`appid` String,
`propertyname` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);


CREATE TABLE tjournal.`TTIMEOUT`(
`ts` DateTime64(6,'Europe/Moscow'),
`duration` Int32,
`name` String,
`level` String,
`process` String,
`processid` String,
`processname` String,
`osthread` Int32,
`clientid` Int32,
`applicationname` String,
`computername` String,
`connectid` Int32,
`sessionid` Int32,
`usr` String,
`appid` String,
`dbms` String,
`database` String,
`trans` Int32,
`dbpid` Int32,
`sql` String,
`rowsaffected` Int32,
`result` String,
`context` String,
`host` String,
`file` String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);





-- ALL EVENTS = ['SCALL', 'ATTN', 'CONN', 'CALL', 'ADMIN', 'EXCP', 'CLSTR', 'Context', 'SESN', 'HASP', 'SRVC', 'DBPOSTGRS', 'VRSREQUEST', 'SDBL', 'VRSRESPONSE', 'TLOCK', 'LIC', 'SCOM', 'EXCPCNTX', 'FTEXTUpd', 'FTS', 'EVENTLOG', 'SDGC', 'DBMSSQL', 'DBMSSQLCONN', 'QERR', 'ADDIN', 'TTIMEOUT']

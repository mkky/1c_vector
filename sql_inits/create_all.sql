--DROP DATABASE IF EXISTS BIT;
--CREATE DATABASE BIT;

-- Создайте базу данных если её нет
CREATE DATABASE IF NOT EXISTS BIT;


CREATE TABLE BIT.LST(
  uid String,
  db_name_1c String,
  comments String,
  db_type String,
  db_descr String,
  db_addr String,
  db_name_subd String,
  db_user String,
  is_license String,
  server String,
  block_rz String,
  file String,
  host String,
) ENGINE = ReplacingMergeTree() ORDER BY (uid, host);


CREATE TABLE BIT.SERVERS(
  file String,
  host String,
  port String,
  range_end String,
  range_start String,
  rport String,
  server String,
) ENGINE = ReplacingMergeTree() ORDER BY (server, host, port, file);



-- Создайте таблицу
CREATE TABLE BIT.JOURNAL_REG
(
    `DateTime` DateTime('UTC') CODEC(Delta(4), LZ4),
    `TransactionStatus` LowCardinality(String),
    `TransactionDate` DateTime('UTC') CODEC(Delta(4), LZ4),
    `TransactionNumber` UInt64 CODEC(Delta(4), LZ4),
    `UserUuid` String CODEC(LZ4),
    `User` String CODEC(ZSTD(9)),
    `Computer` String CODEC(ZSTD(9)),
    `Application` LowCardinality(String),
    `Connection` UInt32 CODEC(DoubleDelta, LZ4),
    `Event` LowCardinality(String),
    `Severity` LowCardinality(String),
    `Comment` String CODEC(ZSTD(19)),
    `MetadataUuid` String CODEC(LZ4),
    `Metadata` String CODEC(ZSTD(19)),
    `Data` String CODEC(ZSTD(19)),
    `DataPresentation` String CODEC(ZSTD(19)),
    `Server` LowCardinality(String),
    `MainPort` UInt16 CODEC(DoubleDelta, LZ4),
    `AddPort` UInt16 CODEC(DoubleDelta, LZ4),
    `Session` UInt32 CODEC(DoubleDelta, LZ4),
    `db_uid` LowCardinality(String),
    `host` LowCardinality(String),
    `FileName` String CODEC(ZSTD(9)),
    `date` Date MATERIALIZED toDate(DateTime)
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(DateTime)
ORDER BY (DateTime, Severity, Event, TransactionNumber)
--TTL DateTime + toIntervalMonth(1) TO VOLUME 'cold_volume',
 --   DateTime + toIntervalYear(1)
SETTINGS index_granularity = 8192 --, storage_policy = 'tiered'
COMMENT 'Журнал регистрации событий 1С';


CREATE TABLE BIT.SCALL(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  interface String,
  iname String,
  method String,
  callid String,
  mname String,
  dstclientid String,
  host String,
  context String,
  file String,
  processname String,
  applicationname String,
  computername String,
  connectid String,
  sessionid String,
  usr String,
  appid String,
  dbms String,
  database String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.ATTN(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  descr String,
  agenturl String,
  host String,
  context String,
  file String,
  url String,
  processid String,
  pid String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.CONN(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  txt String,
  host String,
  context String,
  file String,
  clientid String,
  protected String,
  descr String,
  computername String,
  applicationname String,
  connectid String,
  calls String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.CALL(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  callwait Int32,
  first String,
  interface String,
  iname String,
  method String,
  callid String,
  mname String,
  memory Int64,
  memorypeak Int64,
  inbytes Int64,
  outbytes Int64,
  cputime Int64,
  host String,
  context String,
  file String,
  retexcp String,
  connectid String,
  usr String,
  sessionid String,
  func String,
  module String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.ADMIN(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  func String,
  administrator String,
  result String,
  host String,
  context String,
  file String,
  clusterid String,
  cluster String,
  serverid String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.EXCP(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  descr String,
  host String,
  context String,
  file String,
  processname String,
  applicationname String,
  computername String,
  exception String,
  connectid String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.CLSTR(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  event String,
  data String,
  host String,
  context String,
  file String,
  ref String,
  srcaddr String,
  srcid String,
  srcpid String,
  applicationext String,
  request String,
  dstaddr String,
  dstid String,
  dstpid String,
  rmngrurl String,
  servicename String,
  sessionid String,
  targetcall String,
  processname String,
  connectid String,
  extdata String,
  usr String,
  infobase String,
  distribdata String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.HASP(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  txt String,
  host String,
  context String,
  file String,
  processname String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  sessionid String,
  usr String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.SESN(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  func String,
  ib String,
  appl String,
  nmb String,
  id String,
  host String,
  context String,
  file String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.SRVC(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  descr String,
  host String,
  context String,
  file String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.DBPOSTGRS(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  dbms String,
  database String,
  trans Int32,
  dbpid String,
  sql String,
  rowsaffected Int32,
  result String,
  host String,
  context String,
  file String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  sessionid String,
  usr String,
  appid String,
  prm String,
  func String,
  tablename String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.VRSREQUEST(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  method String,
  uri String,
  headers String,
  body String,
  host String,
  context String,
  file String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.SDBL(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  sessionid String,
  usr String,
  appid String,
  dbms String,
  database String,
  trans Int32,
  sdbl String,
  rows Int32,
  host String,
  context String,
  file String,
  func String,
  sbst String,
  tablename String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.VRSRESPONSE(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  status String,
  phrase String,
  headers String,
  body String,
  host String,
  context String,
  file String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.LIC(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  func String,
  res String,
  txt String,
  host String,
  context String,
  file String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.TLOCK(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  processname String,
  osthread String,
  clientid String,
  applicationname String,
  computername String,
  connectid String,
  sessionid String,
  usr String,
  dbms String,
  database String,
  regions String,
  locks String,
  waitconnections String,
  context String,
  host String,
  file String,
  appid String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE BIT.SCOM(
  ts DateTime64(6,'Europe/Moscow'),
  duration Int64,
  name String,
  depth Int32,
  level String,
  process String,
  osthread String,
  clientid String,
  func String,
  host String,
  context String,
  file String,
  processname String,
  applicationname String,
  computername String,
  connectid String,
  srcprocessname String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);





-- ALL EVENTS = ['LST', 'SERVERS', 'REG', 'SCALL', 'ATTN', 'CONN', 'CALL', 'ADMIN', 'EXCP', 'CLSTR', 'HASP', 'Context', 'SESN', 'SRVC', 'DBPOSTGRS', 'VRSREQUEST', 'SDBL', 'VRSRESPONSE', 'LIC', 'TLOCK', 'SCOM']





CREATE TABLE BIT.PRF(
  db_uid LowCardinality(String),
  operation_target_value Float,
  operation_priority Int16,
  file LowCardinality(String),
  conf_name LowCardinality(String),
  conf_version  LowCardinality(String),
  host LowCardinality(String),
  ts DateTime('UTC'),
  operation_name LowCardinality(String),
  operation_uid LowCardinality(String),
  session_number UInt32,
  time Decimal32(4),
  user LowCardinality(String),
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


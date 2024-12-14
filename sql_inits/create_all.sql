DROP DATABASE IF EXISTS tjournal;
CREATE DATABASE tjournal;




CREATE TABLE tjournal.LST(
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
) ENGINE = ReplacingMergeTree() ORDER BY uid;


CREATE TABLE tjournal.SERVERS(
  file String,
  host String,
  port String,
  range_end String,
  range_start String,
  rport String,
  server String,
) ENGINE = ReplacingMergeTree() ORDER BY (server, host, port, file);


CREATE TABLE tjournal.REG(
  ts DateTime64(6,'Europe/Moscow'),
  TransactionStatus String,
  TransactionDate String,
  TransactionNumber Int32,
  User String,
  UserUuid String,
  Computer String,
  Application String,
  Connection Int32,
  Event String,
  Severity String,
  Comment String,
  Metadata String,
  MetadataUuid String,
  Data String,
  DataPresentation String,
  Server String,
  MainPort UInt16,
  AddPort UInt16,
  Session Int32,
  file String,
  host String,
  db_uid String,
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);


CREATE TABLE tjournal.SCALL(
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


CREATE TABLE tjournal.ATTN(
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


CREATE TABLE tjournal.CONN(
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


CREATE TABLE tjournal.CALL(
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
  memory Int32,
  memorypeak Int32,
  inbytes Int32,
  outbytes Int32,
  cputime Int32,
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


CREATE TABLE tjournal.ADMIN(
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


CREATE TABLE tjournal.EXCP(
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


CREATE TABLE tjournal.CLSTR(
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


CREATE TABLE tjournal.HASP(
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


CREATE TABLE tjournal.SESN(
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


CREATE TABLE tjournal.SRVC(
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


CREATE TABLE tjournal.DBPOSTGRS(
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


CREATE TABLE tjournal.VRSREQUEST(
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


CREATE TABLE tjournal.SDBL(
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


CREATE TABLE tjournal.VRSRESPONSE(
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


CREATE TABLE tjournal.LIC(
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


CREATE TABLE tjournal.TLOCK(
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


CREATE TABLE tjournal.SCOM(
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
CREATE TABLE tjournal.PRF(
  host LowCardinality(String),
  operation_comment LowCardinality(String),
  ts DateTime,
  operation_name LowCardinality(String),
  operation_uid LowCardinality(String),
  session_number UInt32,
  time Decimal32(4),
  user LowCardinality(String),
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts)


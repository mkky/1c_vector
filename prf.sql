CREATE TABLE SystemService.PRF(
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




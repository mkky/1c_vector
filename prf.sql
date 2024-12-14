CREATE TABLE tjournal.PRF(
  host LowCardinality(String),
  operation_comment LowCardinality(String),
  ts DateTime,
  operation_name LowCardinality(String),
  operation_uid LowCardinality(String),
  session_number: UInt32,
  time Decimal32(4),
  user LowCardinality(String),
) ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);




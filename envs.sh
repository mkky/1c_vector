export CLICKHOUSE_USER=chuser
export CLICKHOUSE_PASSWORD=aAAaaaAAAaaa
export CLICKHOUSE_DATABASE=SystemService
export CLICKHOUSE_SERVER=click_house:8123  ## click_house - это имя доступно только из докера
export CLICKHOUSE_ALWAYS_RUN_INITDB_SCRIPTS=1  #   БД при каждом запуска обнуляется

export INT_COLUMNS="depth,duration,callwait,memory,memorypeak,inbytes,outbytes,cputime,trans,rows,rowsaffected,osthread,clientid,connectid,sessionid,waitconnections,dbpid,callid"
#export EVENT_LIST="EXCP,EXCPCNTX,TLOCK,TTIMEOUT,SDBL,QERR,SCALL,CALL"
export EVENT_LIST="Context,SERVERS,LST,TTIMEOUT,TDEADLOCK,ADMIN,CONN,FTEXTUpd,CLSTR,ADDIN,TLOCK,VRSREQUEST,LIC,QERR,ATTN,SCOM,CALL,SRVC,EXCP,HASP,DBMSSQLCONN,DBMSSQL,EXCPCNTX,SCALL,SDBL,EVENTLOG,VRSRESPONSE,SDGC,SESN,FTS,DBPOSTGRS"
#VECTOR_LOG=debug
#RUST_BACKTRACE=full

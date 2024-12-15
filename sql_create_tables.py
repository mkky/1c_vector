# -*- coding: utf-8 -*-

import json
import glob
import re
import os


import sys

if len(sys.argv) == 2:
    LOG_PATH = sys.argv[1]
else:
    LOG_PATH = "/1c/logs/"

LOGS_FILES_PATTERN = LOG_PATH + "**/*.log"

## ['ADMIN', 'CONN', 'DBMSSQLCONN', 'EVENTLOG', 'SCOM', 'SCALL', 'QERR', 'FTEXTUpd', 'TLOCK', 'CALL', 'EXCPCNTX', 'CLSTR', 'ATTN', 'EXCP', 'VRSREQUEST', 'SDBL', 'VRSRESPONSE', 'SRVC', 'LIC', 'ADDIN', 'DBMSSQL', 'SESN', 'HASP', 'FTS', 'Context', 'SDGC']


if 'EVENT_LIST' in os.environ:
    CREATE_ONLY_THIS_TABLES = os.environ['EVENT_LIST'].split(',')
else:
    CREATE_ONLY_THIS_TABLES = None

if 'INT_COLUMNS' in os.environ:
    Int32_COLUMNS = os.environ['INT_COLUMNS'].split(',')
else:
    Int32_COLUMNS = ['duration', 'depth', 'callwait', 'memory', 'memorypeak', 'inbytes', 'outbytes', 'cputime', 'trans',
                     'rows', 'rowsaffected']

set_names = set()
int_cols = set()


def is_datetime(s):
    from datetime import datetime as dt
    try:
        dt.fromisoformat(s)
    except Exception as e:
        return False
    return True


def is_int(s):
    try:
        int(s)
    except Exception as e:
        return False
    return True


def get_db_type(column_name, v):
    if column_name in ['duration', 'memory', 'memorypeak', 'inbytes','outbytes','cputime']:
        return 'Int64'
    elif column_name in Int32_COLUMNS:
        return 'Int32'

    if type(v) == int:
        if 'port' in column_name.lower():
            return 'UInt16'
        else:
            return 'Int32'
    elif type(v) == float:
        return 'Float64'
    elif type(v) == str:
        if is_datetime(v):
            return "DateTime64(6,'Europe/Moscow')"

        # elif is_int(v):
        #     return 'Int32'

        else:
            return 'String'

    return None


print('DROP DATABASE IF EXISTS SystemService;')
print('CREATE DATABASE SystemService;\n\n\n\n')

from collections import defaultdict

columns = defaultdict(dict)

LST_COLS = ['uid', 'db_name_1c', 'comments', 'db_type', 'db_descr', 'db_addr', 'db_name_subd', 'db_user', 'is_license', 'server', 'block_rz', 'file', 'host']
#LST_COLS = ['uid', 'data', 'host']
SERVERS_COLS = ['file', 'host', 'port', 'range_end', 'range_start', 'rport', 'server']
columns['LST'] = dict(zip(LST_COLS, ['string'] * len(LST_COLS)))
columns['SERVERS'] = dict(zip(SERVERS_COLS, ['string'] * len(LST_COLS)))

columns['REG'] = dict({"ts":"2024-07-12T12:28:47.000000", "TransactionStatus":"String", "TransactionDate":"String", "TransactionNumber": 12345, "User": "String",
                       "UserUuid":"String", "Computer": "String", "Application": "String", "Connection": 12345, "Event": "String", "Severity": "String",
                       "Comment": "String", "Metadata": "String", "MetadataUuid": "String", "Data": "String", "DataPresentation": "String", "Server": "String",
                       "MainPort": 12345, "AddPort": 12345, "Session": 12345, "file": "String", "host": "String", "db_uid": "String"})
for file in glob.glob(LOGS_FILES_PATTERN, recursive=True):

    log = open(file, 'r', encoding='utf-8')
    while True:
        l = log.readline()  # .lstrip(' п»ї')

        if l:
            try:
                json_line = json.loads(l)
            except Exception as e:
                continue

            name = json_line['name']
            
            if CREATE_ONLY_THIS_TABLES:
                if name not in CREATE_ONLY_THIS_TABLES:
                    continue


            for k, v in json_line.items():
                k = re.sub('[a-z]+:', "", k.lower())
                if ' ' in k or len(k) > 100:
                   continue
                columns[name][k] = v
            columns[name]['host'] = 'string'
            columns[name]['context'] = 'string'
            columns[name]['file'] = 'string'
        else:
            break

for name, json_line in columns.items():

    if name == 'Context':
        continue

    print(f'CREATE TABLE SystemService.{name}(')

    for k, v in json_line.items():
        
        db_type = get_db_type(k, v)

        if db_type:
            print(f'  {k} {db_type},')
    
    if 'ts' in json_line:
        print(''') ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts) TTL toDateTime(ts) + toIntervalDay(30);\n\n''')
    elif 'uid' in json_line:
        print(') ENGINE = ReplacingMergeTree() ORDER BY (uid, host);\n\n')
    elif 'server' in json_line and 'file' in json_line and 'port' in json_line:
        print(') ENGINE = ReplacingMergeTree() ORDER BY (server, host, port, file);\n\n')
    else:
        print(') ENGINE = TinyLog();\n\n')

print('\n\n\n-- ALL EVENTS = {}'.format(list(columns.keys())))

# -*- coding: utf-8 -*-

import json
import glob
import re
import os


import sys

if len(sys.argv) == 2:
    LOG_PATH = sys.argv[1]
else:
    LOG_PATH = "/mnt/c/Users/User/Downloads/TJ_1C/TJ_LOGS/"

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
    if column_name in Int32_COLUMNS:
        return 'Int32'

    if type(v) == int:
        return 'Int32'
    elif type(v) == float:
        return 'Float6  4'
    elif type(v) == str:
        if is_datetime(v):
            return "DateTime64(6,'Europe/Moscow')"

        # elif is_int(v):
        #     return 'Int32'

        else:
            return 'String'

    return None


print('DROP DATABASE IF EXISTS tjournal;')
print('CREATE DATABASE tjournal;\n\n\n\n')

from collections import defaultdict

columns = defaultdict(dict)

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

            for k, v in json_line.items():
                k = re.sub('[a-z]+:', "", k.lower())
                columns[name][k] = v

        else:
            break

for name, json_line in columns.items():

    if CREATE_ONLY_THIS_TABLES:
        if name not in CREATE_ONLY_THIS_TABLES:
            continue

    if name == 'Context':
        continue

    # print('-- ' + l)
    print(f'CREATE TABLE tjournal.`{name}`(')
    # print('`host` String,')
    # print('`context` String,')
    # print('`file` String,')

    json_line['host'] = 'string'
    json_line['context'] = 'string'
    json_line['file'] = 'string'

    for k, v in json_line.items():

        db_type = get_db_type(k, v)

        if db_type:
            print(f'`{k}` {db_type},')

    print(''') ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);\n\n''')

print('\n\n\n-- ALL EVENTS = {}'.format(list(columns.keys())))

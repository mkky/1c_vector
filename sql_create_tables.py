import json
import glob
import re

# LOGS_FILES_PATTERN = "./logs/*/*.log"

#Читаются все эти логи, и для каждой первой строки с уникальным name создаётся таблица name
LOGS_FILES_PATTERN = "C:\\Users\\User\\Downloads\\TJ_1C\\TJ_LOGS\\**\\*.log"

set_names = set()

def is_datetime(s):
    from datetime import datetime as dt
    try:
        dt.fromisoformat(s)
    except Exception as e:
        return False
    return True


def get_db_type(v):
    if type(v) == int:
        return 'Int32'
    elif type(v) == float:
        return 'Float64'
    elif type(v) == str:
        if is_datetime(v):
            return "DateTime64(6,'UTC')"
        else:
            return 'String'

    return None


print('DROP DATABASE IF EXISTS tjournal;')
print('CREATE DATABASE tjournal;\n\n\n\n')


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

            if name in set_names:
                continue
            else:
                set_names.add(name)
            # print('-- ' + l)
            print(f'CREATE TABLE tjournal.`{name}`(')
            print('`host` String,')

            for k, v in json_line.items():

                column_name = k.lower().replace('t:', '')
                column_name = re.sub('[a-z]+:', "", k.lower())
                db_type = get_db_type(v)

                if db_type:
                    print(f'`{column_name}` {db_type},')

            print(''') ENGINE = MergeTree() PARTITION BY toYYYYMM(ts)
ORDER BY (ts);\n\n''')
            # break
        else:
            break

print('\n\n\n-- ALL TABLES = {}'.format(list(set_names)))

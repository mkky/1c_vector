from sys import stdin


import re
buffer=''
level = 0
END_OF_LIST=False
d = dict()
for l in stdin.readlines():
  #print('###  {}'.format(d))
  match = re.search(r"\{(\d+),[^\{\}]*\r\n", l)
  if match:
      d[level] = int(match.group(1))
      buffer += '['
      continue
  else:
     #buffer = ''
     for c in l:
         if END_OF_LIST:
             if c == ',':
                 END_OF_LIST = False
             continue
         buffer += c
         if c == '{':
             level += 1
         elif c == '}':
             level -= 1
         
             if level in d:
                 d[level] -= 1
                 if d[level] == 0:
                     buffer += '],\n'
                     END_OF_LIST=True

#buffer= buffer[:-1] + ']'
buffer = re.sub("([01]{14,20})",r'"\1"', buffer)

buffer = re.sub(r"([a-z\d]{8}\-[a-z\d]{4}\-[a-z\d]{4}\-[a-z\d]{4}\-[a-z\d]{12})",r'"\1"', buffer)
buffer = re.sub(r',"[^,]*?DB=[^,]*?",', ",", buffer)
buffer = buffer.replace("{", "[").replace("}", "]") 
#print(buffer)
import  json
data = json.loads(buffer)

server=data[0][3]
servers = {}
for _ in data[4]:
    servers[_[3]] = {
            'range_start': str(_[5][0][0]),
            'port':str(_ [2]),
            'regport': str(_[18]),
            'range_end': str(_[5][0][1])
            }


dbs = []
header = ['uid', 'db_name_1c', 'comments','db_type','db_addr','db_name_subd','db_user', 'port', 'regport', 'range_start', 'range_end', 'server']

print(';'.join(header))
for _ in data[1]:
    srv = servers.get(server, {})
    csv_line =  [ _[0],  _[1],  _[2].replace(";", ""), _[3], _[4], _[5], _[6], srv['port'], srv['regport'], srv['range_start'], srv['range_end'], server]
    print(';'.join(csv_line))
      
#print(json.dumps(servers, indent=True))
#print(json.dumps(dbs, indent=True, ensure_ascii=False))

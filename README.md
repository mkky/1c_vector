# 1c_vector

Для запуска выполнить
docker-compose up --force-recreate

будут запущены в докере Вектор и КликХаус

Логи будут читаться из папки ./logs, 
после обработки данные пишутся в БД (и в папку ./tmp если указано в конфигt vector/vector.yaml)

в файле envs.sh содержится переменная EVENT_LIST в которой записаны типы фильтруемых сообщений.


скрипт  sql_create_tables.py читает логи отсюда LOGS_FILES_PATTERN = "C:\\Users\\User\\Downloads\\TJ_1C\\TJ_LOGS\\**\\*.log" (данной папки в репозитории нету)
и печатает  в stdout скрипты создания всех нужных таблиц. Его запускать не надо. Результат его работы уже сохранён в sql_inits/create_all.sql.
Данный sql скрипт указан в композе файле, и запускается при каждом запуске докер композ.

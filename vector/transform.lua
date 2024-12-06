dictonaryIndex = {"users","computers","applications","events","metadata","servers","ports","portsAdd"}
--dictonaries = {users={}, computers={}, applications={}, events={}, metadata={}, servers={}, ports={}, portsAdd={}}
dictonaries = {}

startEpoch = -62135632799
dictonaryFilePath = nil
fileProcessing = nil
--env_onec_logs_debug = os.getenv("onec_logs_debug")

function tableLength(table)
  count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

function split(inputstr, sep)
  if sep == nil then sep = "%s" end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
  return t
end

function getPath(str)
    return str:match("(.*[/\\/])")
end

function loadDictonary(file, db)
  
  dictonaryFilePath = getPath(file).."1Cv8.lgf"
   
  --print("DICTONARY RELOAD: "..dictonaryFilePath)

  local file = io.open(dictonaryFilePath, "r")
    if not file then 
      print("DICTONARY not found: "..dictonaryFilePath)
      return nil 
    end
    local file_content = file:read "*a"
    file:close()
  
  if dictonaries[db] == nil then
    dictonaries[db] = {users={}, computers={}, applications={}, events={}, metadata={}, servers={}, ports={}, portsAdd={}}
  end
  for dictonary_type, data, id in file_content:gmatch('\n{(%d+),(.-),(%d+)}') do
    local dtype = tonumber(dictonary_type)
    if (dtype > 0) and (dtype < 9) then
      dictonaries[db][dictonaryIndex[dtype]][id] = data
    end
  end

  for dictonary_type, data, id in file_content:gmatch('\n{(%d+),(%w+-%w+-%w+-%w+-%w+,".-"),(%d+)}') do
    local dtype = tonumber(dictonary_type)
    if (dtype > 0) and (dtype < 9) then
      dictonaries[db][dictonaryIndex[dtype]][id] = data
    end
  end
end

-- return {value, status = true - найден, false - не найден, nil - для поиска передано нулевое значение}
-- 
function getDictonaryValue(file, db, id, type)
  if id ~= "0" then
    --loadDictonary(db)
    local status, value  = pcall(function() return dictonaries[db][type][id] end, type, id)
    if status == false then
      --print("DICTONARY FIND ERROR: type["..type.."]["..id.."]",value)
      value = nil
    end  
    
    if value ~= nil then 
      return {value=value, status=true}  
    else
      if lastReloadDictonary < processed then -- Обновим словарь если на этой строке лога мы его еще не обновляли
        loadDictonary(file, db)
        lastReloadDictonary = processed
        value = dictonaries[db][type][id] -- Повторим поиск
          if value ~= nil then 
            return {value=value, status=true}  
          else
            --print("vallue is nil for type=" .. type)
            return {value=id, status=false}
          end
      else -- словарь уже обновлен поэтому вернес статус что значение не найдено
        return {value=id, status=false} 
      end
    end
  else
    return {value=id, status=nil}  
  end
end


--------------------------- EVENTS TRANSLATE--------------------


dict_events= {
 ["_$Access$_.Access"] = "Доступ.Доступ",
                ["_$Access$_.AccessDenied"] = "Доступ.Отказ в доступе",
                ["_$Data$_.Delete"] = "Данные.Удаление",
                ["_$Data$_.DeletePredefinedData"] = " Данные.Удаление предопределенных данных",
                ["_$Data$_.DeleteVersions"] = "Данные.Удаление версий",
                ["_$Data$_.New"] = "Данные.Добавление",
                ["_$Data$_.NewPredefinedData"] = "Данные.Добавление предопределенных данных",
                ["_$Data$_.NewVersion"] = "Данные.Добавление версии",
                ["_$Data$_.Pos"] = "Данные.Проведение",
                ["_$Data$_.PredefinedDataInitialization"] = "Данные.Инициализация предопределенных данных",
                ["_$Data$_.PredefinedDataInitializationDataNotFound"] = "Данные.Инициализация предопределенных данных.Данные не найдены",
                ["_$Data$_.SetPredefinedDataInitialization"] = "Данные.Установка инициализации предопределенных данных",
                ["_$Data$_.SetStandardODataInterfaceContent"] = "Данные.Изменение состава стандартного интерфейса OData",
                ["_$Data$_.TotalsMaxPeriodUpdate"] = "Данные.Изменение максимального периода рассчитанных итогов",
                ["_$Data$_.TotalsMinPeriodUpdate"] = "Данные.Изменение минимального периода рассчитанных итогов",
                ["_$Data$_.Post"] = "Данные.Проведение",
                ["_$Data$_.Unpost"] = "Данные.Отмена проведения",
                ["_$Data$_.Update"] = "Данные.Изменение",
                ["_$Data$_.UpdatePredefinedData"] = "Данные.Изменение предопределенных данных",
                ["_$Data$_.VersionCommentUpdate"] = "Данные.Изменение комментария версии",
                ["_$InfoBase$_.ConfigExtensionUpdate"] = "Информационная база.Изменение расширения конфигурации",
                ["_$InfoBase$_.ConfigUpdate"] = "Информационная база.Изменение конфигурации",
                ["_$InfoBase$_.DBConfigBackgroundUpdateCancel"] = "Информационная база.Отмена фонового обновления",
                ["_$InfoBase$_.DBConfigBackgroundUpdateFinish"] = "Информационная база.Завершение фонового обновления",
                ["_$InfoBase$_.DBConfigBackgroundUpdateResume"] = "Информационная база.Продолжение (после приостановки) процесса фонового обновления",
                ["_$InfoBase$_.DBConfigBackgroundUpdateStart"] = "Информационная база.Запуск фонового обновления",
                ["_$InfoBase$_.DBConfigBackgroundUpdateSuspend"] = "Информационная база.Приостановка (пауза) процесса фонового обновления",
                ["_$InfoBase$_.DBConfigExtensionUpdate"] = "Информационная база.Изменение расширения конфигурации",
                ["_$InfoBase$_.DBConfigExtensionUpdateError"] = "Информационная база.Ошибка изменения расширения конфигурации",
                ["_$InfoBase$_.DBConfigUpdate"] = "Информационная база.Изменение конфигурации базы данных",
                ["_$InfoBase$_.DBConfigUpdateStart"] = "Информационная база.Запуск обновления конфигурации базы данных",
                ["_$InfoBase$_.DumpError"] = "Информационная база.Ошибка выгрузки в файл",
                ["_$InfoBase$_.DumpFinish"] = "Информационная база.Окончание выгрузки в файл",
                ["_$InfoBase$_.DumpStart"] = "Информационная база.Начало выгрузки в файл",
                ["_$InfoBase$_.EraseData"] = " Информационная база.Удаление данных информационной баз",
                ["_$InfoBase$_.EventLogReduce"] = "Информационная база.Сокращение журнала регистрации",
                ["_$InfoBase$_.EventLogReduceError"] = "Информационная база.Ошибка сокращения журнала регистрации",
                ["_$InfoBase$_.EventLogSettingsUpdate"] = "Информационная база.Изменение параметров журнала регистрации",
                ["_$InfoBase$_.EventLogSettingsUpdateError"] = "Информационная база.Ошибка при изменение настроек журнала регистрации",
                ["_$InfoBase$_.InfoBaseAdmParamsUpdate"] = "Информационная база.Изменение параметров информационной базы",
                ["_$InfoBase$_.InfoBaseAdmParamsUpdateError"] = "Информационная база.Ошибка изменения параметров информационной базы",
                ["_$InfoBase$_.IntegrationServiceActiveUpdate"] = "Информационная база.Изменение активности сервиса интеграции",
                ["_$InfoBase$_.IntegrationServiceSettingsUpdate"] = "Информационная база.Изменение настроек сервиса интеграции",
                ["_$InfoBase$_.MasterNodeUpdate"] = "Информационная база.Изменение главного узла",
                ["_$InfoBase$_.PredefinedDataUpdate"] = "Информационная база.Обновление предопределенных данных",
                ["_$InfoBase$_.RegionalSettingsUpdate"] = "Информационная база.Изменение региональных установок",
                ["_$InfoBase$_.RestoreError"] = "Информационная база.Ошибка загрузки из файла",
                ["_$InfoBase$_.RestoreFinish"] = "Информационная база.Окончание загрузки из файла",
                ["_$InfoBase$_.RestoreStart"] = "Информационная база.Начало загрузки из файла",
                ["_$InfoBase$_.SecondFactorAuthTemplateDelete"] = "Информационная база.Удаление шаблона вторго фактора аутентификации",
                ["_$InfoBase$_.SecondFactorAuthTemplateNew"] = "Информационная база.Добавление шаблона вторго фактора аутентификации",
                ["_$InfoBase$_.SecondFactorAuthTemplateUpdate"] = "Информационная база.Изменение шаблона вторго фактора аутентификации",
                ["_$InfoBase$_.SetPredefinedDataUpdate"] = "Информационная база.Установить обновление предопределенных данных",
                ["_$InfoBase$_.TARImportant"] = "Тестирование и исправление.Ошибка",
                ["_$InfoBase$_.TARInfo"] = "Тестирование и исправление.Сообщение",
                ["_$InfoBase$_.TARMess"] = "Тестирование и исправление.Предупреждение",
                ["_$Job$_.Cancel"] = "Фоновое задание.Отмена",
                ["_$Job$_.Fail"] = "Фоновое задание.Ошибка выполнения",
                ["_$Job$_.Start"] = "Фоновое задание.Запуск",
                ["_$Job$_.Succeed"] = "Фоновое задание.Успешное завершение",
                ["_$Job$_.Terminate"] = "Фоновое задание.Принудительное завершение",
                ["_$OpenIDProvider$_.NegativeAssertion"] = "Провайдер OpenID.Отклонено",
                ["_$OpenIDProvider$_.PositiveAssertion"] = "Провайдер OpenID.Подтверждено",
                ["_$PerformError$_"] = "Ошибка выполнения",
                ["_$Session$_.Authentication"] = "Сеанс.Аутентификация",
                ["_$Session$_.AuthenticationError"] = "Сеанс.Ошибка аутентификации",
                ["_$Session$_.AuthenticationFirstFactor"] = "Сеанс.Аутентификация первый фактор",
                ["_$Session$_.ConfigExtensionApplyError"] = "Сеанс.Ошибка применения расширения конфигурации",
                ["_$Session$_.Finish"] = "Сеанс.Завершение",
                ["_$Session$_.Start"] = "Сеанс.Начало",
                ["_$Transaction$_.Begin"] = "Транзакция.Начало",
                ["_$Transaction$_.Commit"] = "Транзакция.Фиксация",
                ["_$Transaction$_.Rollback"] = "Транзакция.Отмена",
                ["_$User$_.AuthenticationLock"] = "Пользователи.Блокировка аутентификации",
                ["_$User$_.AuthenticationUnlock"] = "Пользователи.Разблокировка аутентификации",
                ["_$User$_.AuthenticationUnlockError "] = "Пользователи.Ошибка разблокировки аутентификации",
                ["_$User$_.Delete"] = "Пользователи.Удаление",
                ["_$User$_.DeleteError"] = "Пользователи.Ошибка удаления",
                ["_$User$_.New"] = "Пользователи.Добавление",
                ["_$User$_.NewError"] = "Пользователи.Ошибка добавления",
                ["_$User$_.Update"] = "Пользователи.Изменение",
                ["_$User$_.UpdateError"] = "Пользователи. Ошибка изменения",
}

--print (dict_events["_$Job$_.Fail"])


--------------------------- TIMER ------------------------------

function timer_handler (emit)
  if env_onec_logs_debug == "true" then
    print("============================================================")
    print(os.date('%Y-%m-%d %H:%M:%S'), "PROCESSES", processed, "ERRORS", errorCount)
    print("============================================================")
  end
end

--------------------------- HOOKS ------------------------------

function init (emit)
    processed = 0
    errorCount = 0
    lastReloadDictonary = -1
end

function shutdown (emit)
end

function process (event, emit)
      local status = nil
      local result = {}
      processed = processed + 1
      fileProcessing = event.log.file
      
      event.log.UserUuid = ""
      event.log.MetadataUuid = ""
      event.log.errLUA = nil
      
      --------------------------- USER ------------------------------
        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.User, "users")
        if status == true then -- проверка на исключение
          if result.status == true then
            local userObj = split(result.value, ",")
            event.log.UserUuid = userObj[1]
            event.log.User     = userObj[2]:gsub('"','')
          end
        else
          print("ERROR User", result)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  
 
     --------------------------- COMPUTER ------------------------------
        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.Computer, "computers")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.Computer = result.value:gsub('"','')
          end
        else
          print("ERROR Computer", result, "input", event.log.User)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  
     --------------------------- APPLICATION ------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.Application, "applications")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.Application = result.value:gsub('"','')
          end
        else
          print("ERROR Application", result, "input", event.log.Application)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end
     ------------------------------ EVENT ----------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.Event, "events")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.Event = result.value:gsub('"','')
	    translated = dict_events[event.log.Event]
            if translated ~= nil then
              event.log.Event = translated
            end
          end
        else
          print("ERROR Event", result, "input", event.log.Event)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  

     ------------------------------ METADATA --------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.Metadata, "metadata")
        if status == true then -- проверка на исключение
          if result.status == true then
            local metaObj = split(result.value,",")
            event.log.MetadataUuid = metaObj[1]
            event.log.Metadata     = metaObj[2]          
          end
        else
          print("ERROR Metadata", result, "input", event.log.Metadata)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  

     -------------------------------- SERVER --------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.Server, "servers")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.Server = result.value:gsub('"','')
          end
        else
          print("ERROR Server", result, "input", event.log.Server)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  

     ------------------------------ PORT ----------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.MainPort, "ports")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.MainPort = result.value
          end
        else
          print("ERROR MainPort", result, "input", event.log.MainPort)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  

     ------------------------------ PORTADD --------------------------------

        status, result = pcall(getDictonaryValue, event.log.file, event.log.db_uid, event.log.AddPort, "portsAdd")
        if status == true then -- проверка на исключение
          if result.status == true then
            event.log.AddPort = result.value
          end
        else
          print("ERROR AddPort", result, "input", event.log.AddPort)
          event.log.errLUA  = true
          event.log.err     = result
          errorCount = errorCount + 1
        end  

     ------------------------- TRANSACTION STATUS --------------------------

        result = event.log.TransactionStatus
        if     result == "N" then event.log.TransactionStatus = "Отсутствует"
        elseif result == "U" then event.log.TransactionStatus = "Зафиксирована"
        elseif result == "R" then event.log.TransactionStatus = "Не завершена"
        elseif result == "C" then event.log.TransactionStatus = "Отменена"
        end

     ------------------------------ SEVERITY --------------------------------

        result = event.log.Severity
        if     result == "I" then event.log.Severity = "Информация"
        elseif result == "E" then event.log.Severity = "Ошибка"
        elseif result == "W" then event.log.Severity = "Предупреждение"
        elseif result == "N" then event.log.Severity = "Примечание"
        end

     --------------- TRANSACTION DATE, TRANSACTION NUMBER --------------------
        
        local TransactionObj   = split(event.log.TransactionDate,",")
        local transactionDate  = TransactionObj[1]
        local transactionNumber= TransactionObj[2]
        if transactionDate ~= "0" then
          event.log.TransactionDate   = math.ceil(startEpoch + (tonumber(transactionDate,16) / 10000))
          event.log.TransactionNumber = tonumber(transactionNumber,16)
        else
          event.log.TransactionDate  = 0
        end

     --------------------------------------------------------------------------

      emit(event)
end

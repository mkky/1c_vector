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
  for dictonary_type, data, id in file_content:gmatch('\n{(%d+),"(.-)",(%d+)}') do
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
      if lastReloadDictonary < processed  and type == "users" then -- Обновим словарь если на этой строке лога мы его еще не обновляли
        loadDictonary(file, db)
        lastReloadDictonary = processed
        value = dictonaries[db][type][id] -- Повторим поиск
          if value ~= nil then 
            return {value=value, status=true}  
          else
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
            event.log.Event = result.value
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

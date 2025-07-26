package main

import (
    "bufio"
    "encoding/csv"
    "errors"
    "flag"
    "fmt"
    "os"
    "path/filepath"
    "regexp"
    "strings"
    "time"
)

type SectionData map[string]string

// ------------------ Общие для .v8i ------------------

type OrderedSet struct {
    keys  map[string]struct{}
    order []string
}

func NewOrderedSet() *OrderedSet {
    return &OrderedSet{make(map[string]struct{}), []string{}}
}

func (o *OrderedSet) Add(item string) {
    if _, ok := o.keys[item]; !ok {
        o.keys[item] = struct{}{}
        o.order = append(o.order, item)
    }
}

func (o *OrderedSet) Items() []string {
    return o.order
}

func parseComplexField(mainKey, value string) map[string]string {
    result := make(map[string]string)
    prefix := mainKey + "_"
    for _, entry := range strings.Split(value, ";") {
        entry = strings.TrimSpace(entry)
        if entry == "" {
            continue
        }
        kv := strings.SplitN(entry, "=", 2)
        if len(kv) == 2 {
            k := prefix + kv[0]
            v := strings.Trim(kv[1], `"`)
            result[k] = v
        }
    }
    return result
}

func parseV8iFile(path string) ([]SectionData, error) {
    file, err := os.Open(path)
    if err != nil {
        return nil, err
    }
    defer file.Close()
    scanner := bufio.NewScanner(file)
    var current SectionData
    var out []SectionData
    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        line = strings.TrimLeft(line, "\ufeff")
        if line == "" || strings.HasPrefix(line, ";") {
            continue
        }
        if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
            if current != nil && len(current) > 0 {
                out = append(out, current)
            }
            current = make(SectionData)
            current["name"] = line[1 : len(line)-1]
        } else if current != nil {
            parts := strings.SplitN(line, "=", 2)
            if len(parts) != 2 {
                continue
            }
            k := strings.TrimSpace(parts[0])
            v := strings.TrimSpace(parts[1])
            if strings.Contains(v, ";") &&
                (strings.HasPrefix(v, "Srvr=") ||
                    strings.HasPrefix(v, "File=") ||
                    strings.HasPrefix(v, "Ref=")) {
                m := parseComplexField(k, v)
                for sk, sv := range m {
                    current[sk] = sv
                }
                current[k] = v
            } else {
                current[k] = v
            }
        }
    }
    if current != nil && len(current) > 0 {
        out = append(out, current)
    }
    if len(out) == 0 {
        return nil, errors.New("no sections in " + path)
    }
    return out, nil
}

// ------------------ Общие для .lgf ------------------

// ------------------ Общие для .lgf ------------------
var (
    // Словарь событий
    dictEvents = map[string]string{
        "_$Access$_.Access": "Доступ.Доступ",
        "_$Access$_.AccessDenied": "Доступ.Отказ в доступе",
        "_$Data$_.Delete": "Данные.Удаление",
        "_$Data$_.DeletePredefinedData": "Данные.Удаление предопределенных данных",
        "_$Data$_.DeleteVersions": "Данные.Удаление версий",
        "_$Data$_.New": "Данные.Добавление",
        "_$Data$_.NewPredefinedData": "Данные.Добавление предопределенных данных",
        "_$Data$_.NewVersion": "Данные.Добавление версии",
        "_$Data$_.Pos": "Данные.Проведение",
        "_$Data$_.PredefinedDataInitialization": "Данные.Инициализация предопределенных данных",
        "_$Data$_.PredefinedDataInitializationDataNotFound": "Данные.Инициализация предопределенных данных.Данные не найдены",
        "_$Data$_.SetPredefinedDataInitialization": "Данные.Установка инициализации предопределенных данных",
        "_$Data$_.SetStandardODataInterfaceContent": "Данные.Изменение состава стандартного интерфейса OData",
        "_$Data$_.TotalsMaxPeriodUpdate": "Данные.Изменение максимального периода рассчитанных итогов",
        "_$Data$_.TotalsMinPeriodUpdate": "Данные.Изменение минимального периода рассчитанных итогов",
        "_$Data$_.Post": "Данные.Проведение",
        "_$Data$_.Unpost": "Данные.Отмена проведения",
        "_$Data$_.Update": "Данные.Изменение",
        "_$Data$_.UpdatePredefinedData": "Данные.Изменение предопределенных данных",
        "_$Data$_.VersionCommentUpdate": "Данные.Изменение комментария версии",
        "_$InfoBase$_.ConfigExtensionUpdate": "Информационная база.Изменение расширения конфигурации",
        "_$InfoBase$_.ConfigUpdate": "Информационная база.Изменение конфигурации",
        "_$InfoBase$_.DBConfigBackgroundUpdateCancel": "Информационная база.Отмена фонового обновления",
        "_$InfoBase$_.DBConfigBackgroundUpdateFinish": "Информационная база.Завершение фонового обновления",
        "_$InfoBase$_.DBConfigBackgroundUpdateResume": "Информационная база.Продолжение (после приостановки) процесса фонового обновления",
        "_$InfoBase$_.DBConfigBackgroundUpdateStart": "Информационная база.Запуск фонового обновления",
        "_$InfoBase$_.DBConfigBackgroundUpdateSuspend": "Информационная база.Приостановка (пауза) процесса фонового обновления",
        "_$InfoBase$_.DBConfigExtensionUpdate": "Информационная база.Изменение расширения конфигурации",
        "_$InfoBase$_.DBConfigExtensionUpdateError": "Информационная база.Ошибка изменения расширения конфигурации",
        "_$InfoBase$_.DBConfigUpdate": "Информационная база.Изменение конфигурации базы данных",
        "_$InfoBase$_.DBConfigUpdateStart": "Информационная база.Запуск обновления конфигурации базы данных",
        "_$InfoBase$_.DumpError": "Информационная база.Ошибка выгрузки в файл",
        "_$InfoBase$_.DumpFinish": "Информационная база.Окончание выгрузки в файл",
        "_$InfoBase$_.DumpStart": "Информационная база.Начало выгрузки в файл",
        "_$InfoBase$_.EraseData": "Информационная база.Удаление данных информационной базы",
        "_$InfoBase$_.EventLogReduce": "Информационная база.Сокращение журнала регистрации",
        "_$InfoBase$_.EventLogReduceError": "Информационная база.Ошибка сокращения журнала регистрации",
        "_$InfoBase$_.EventLogSettingsUpdate": "Информационная база.Изменение параметров журнала регистрации",
        "_$InfoBase$_.EventLogSettingsUpdateError": "Информационная база.Ошибка при изменение настроек журнала регистрации",
        "_$InfoBase$_.InfoBaseAdmParamsUpdate": "Информационная база.Изменение параметров информационной базы",
        "_$InfoBase$_.InfoBaseAdmParamsUpdateError": "Информационная база.Ошибка изменения параметров информационной базы",
        "_$InfoBase$_.IntegrationServiceActiveUpdate": "Информационная база.Изменение активности сервиса интеграции",
        "_$InfoBase$_.IntegrationServiceSettingsUpdate": "Информационная база.Изменение настроек сервиса интеграции",
        "_$InfoBase$_.MasterNodeUpdate": "Информационная база.Изменение главного узла",
        "_$InfoBase$_.PredefinedDataUpdate": "Информационная база.Обновление предопределенных данных",
        "_$InfoBase$_.RegionalSettingsUpdate": "Информационная база.Изменение региональных установок",
        "_$InfoBase$_.RestoreError": "Информационная база.Ошибка загрузки из файла",
        "_$InfoBase$_.RestoreFinish": "Информационная база.Окончание загрузки из файла",
        "_$InfoBase$_.RestoreStart": "Информационная база.Начало загрузки из файла",
        "_$InfoBase$_.SecondFactorAuthTemplateDelete": "Информационная база.Удаление шаблона вторго фактора аутентификации",
        "_$InfoBase$_.SecondFactorAuthTemplateNew": "Информационная база.Добавление шаблона вторго фактора аутентификации",
        "_$InfoBase$_.SecondFactorAuthTemplateUpdate": "Информационная база.Изменение шаблона вторго фактора аутентификации",
        "_$InfoBase$_.SetPredefinedDataUpdate": "Информационная база.Установить обновление предопределенных данных",
        "_$InfoBase$_.TARImportant": "Тестирование и исправление.Ошибка",
        "_$InfoBase$_.TARInfo": "Тестирование и исправление.Сообщение",
        "_$InfoBase$_.TARMess": "Тестирование и исправление.Предупреждение",
        "_$Job$_.Cancel": "Фоновое задание.Отмена",
        "_$Job$_.Error": "Фоновое задание.Ошибка выполнения",
        "_$Job$_.Fail": "Фоновое задание.Ошибка",
        "_$Job$_.Finish": "Фоновое задание.Успешное завершение",
        "_$Job$_.Start": "Фоновое задание.Запуск",
        "_$OpenIDProvider$_.NegativeAssertion": "Провайдер OpenID.Отклонено",
        "_$OpenIDProvider$_.PositiveAssertion": "Провайдер OpenID.Подтверждено",
        "_$PerformError$_": "Ошибка выполнения",
        "_$Session$_.Authentication": "Сеанс.Аутентификация",
        "_$Session$_.AuthenticationError": "Сеанс.Ошибка аутентификации",
        "_$Session$_.AuthenticationFirstFactor": "Сеанс.Аутентификация первый фактор",
        "_$Session$_.ConfigExtensionApplyError": "Сеанс.Ошибка применения расширения конфигурации",
        "_$Session$_.Finish": "Сеанс.Завершение",
        "_$Session$_.Start": "Сеанс.Начало",
        "_$Transaction$_.Begin": "Транзакция.Начало",
        "_$Transaction$_.Commit": "Транзакция.Фиксация",
        "_$Transaction$_.Rollback": "Транзакция.Отмена",
        "_$User$_.AuthenticationLock": "Пользователи.Блокировка аутентификации",
        "_$User$_.AuthenticationUnlock": "Пользователи.Разблокировка аутентификации",
        "_$User$_.AuthenticationUnlockError": "Пользователи.Ошибка разблокировки аутентификации",
        "_$User$_.Delete": "Пользователи.Удаление",
        "_$User$_.DeleteError": "Пользователи.Ошибка удаления",
        "_$User$_.New": "Пользователи.Добавление",
        "_$User$_.NewError": "Пользователи.Ошибка добавления",
        "_$User$_.Update": "Пользователи.Изменение",
        "_$User$_.UpdateError": "Пользователи.Ошибка изменения",
    }

    // Словарь приложений
    dictApps = map[string]string{
        "1CV8":               "Толстый клиент",
        "1CV8C":              "Тонкий клиент",
        "WebClient":          "Веб-клиент",
        "Designer":           "Конфигуратор",
        "COMConnection":      "Внешнее соединение (COM, обычное)",
        "WSConnection":       "Сессия web-сервиса",
        "BackgroundJob":      "Фоновое задание",
        "SystemBackgroundJob":"Системное фоновое задание",
        "SrvrConsole":        "Консоль кластера",
        "COMConsole":         "Внешнее соединение (COM, административное)",
        "JobScheduler":       "Планировщик заданий",
        "Debugger":           "Отладчик",
        "RAS":                "Сервер администрирования",
        "HTTPServiceConnection": "Соединение с HTTP-сервисом",
        "ODataConnection":    "Соединение с автоматическим REST API",
    }

    // Типы записей lgf → имя
    typeNames = map[string]string{
        "1": "users",
        "2": "computers",
        "3": "applications",
        "4": "events",
        "5": "metadata",
        "6": "servers",
        "7": "ports",
        "8": "portsAdd",
    }
)

func processLGF(inMask, outCsv string) error {
    files, err := filepath.Glob(inMask)
    if err != nil {
        return err
    }
    re4 := regexp.MustCompile(`^\{([15]),([^,]+),([^,]+),(\d+)\}`)
    re3 := regexp.MustCompile(`^\{([1-8]),([^,}]+),(\d+)\}`)
    var records [][]string
    records = append(records, []string{"type", "db_uid", "uuid", "value", "id"})
    for _, path := range files {
        elems := strings.Split(path, string(os.PathSeparator))
        var dbuid string
        for i, e := range elems {
            if strings.EqualFold(e, "1Cv8Log") && i > 0 {
                dbuid = elems[i-1]
                break
            }
        }
        if dbuid == "" {
            fmt.Fprintf(os.Stderr, "Warn: db_uid not found in path %s\n", path)
            continue
        }
        f, err := os.Open(path)
        if err != nil {
            fmt.Fprintf(os.Stderr, "Warn open %s: %v\n", path, err)
            continue
        }
        sc := bufio.NewScanner(f)
        for sc.Scan() {
            line := strings.TrimSpace(sc.Text())
            if !strings.HasPrefix(line, "{") {
                continue
            }
            if m := re4.FindStringSubmatch(line); m != nil {
                tnum, uuid, rawVal, id := m[1], m[2], m[3], m[4]
                val := strings.Trim(rawVal, `"`)
                tname := typeNames[tnum]
                if tname == "events" {
                    if v, ok := dictEvents[val]; ok {
                        val = v
                    }
                } else if tname == "applications" {
                    if v, ok := dictApps[val]; ok {
                        val = v
                    }
                }
                records = append(records, []string{tname, dbuid, uuid, val, id})
                continue
            }
            if m := re3.FindStringSubmatch(line); m != nil {
                tnum, rawVal, id := m[1], m[2], m[3]
                val := strings.Trim(rawVal, `"`)
                tname := typeNames[tnum]
                if tname == "events" {
                    if v, ok := dictEvents[val]; ok {
                        val = v
                    }
                } else if tname == "applications" {
                    if v, ok := dictApps[val]; ok {
                        val = v
                    }
                }
                records = append(records, []string{tname, dbuid, "", val, id})
            }
        }
        f.Close()
    }
    out, err := os.Create(outCsv)
    if err != nil {
        return err
    }
    defer out.Close()
    w := csv.NewWriter(out)
    defer w.Flush()
    for _, row := range records {
        if err := w.Write(row); err != nil {
            return err
        }
    }
    return nil
}

// ------------------ main ------------------

func main() {
    var (
        inputMask, outCsv  string
        lgfMask, lgfOutCsv string
        interval           int
    )

    flag.StringVar(&inputMask, "input", "", "glob pattern for v8i files")
    flag.StringVar(&outCsv, "out", "", "output csv for v8i merge")
    flag.StringVar(&lgfMask, "lgf-input", "", "glob pattern for lgf files")
    flag.StringVar(&lgfOutCsv, "lgf-out", "", "output csv for lgf parsing")
    flag.IntVar(&interval, "interval", 0, "seconds to wait between scans (0=once)")
    flag.Parse()

    if inputMask == "" && lgfMask == "" {
        fmt.Println("Use:")
        fmt.Println("  --input  \"*.v8i\"  --out dict_bases.csv")
        fmt.Println("  --lgf-input \"*.lgf\" --lgf-out dict_lgf.csv")
        fmt.Println("  [--interval N]")
        os.Exit(1)
    }

    // Переменные для .v8i
    globalCols := NewOrderedSet()
    var allSections []SectionData
    modV8i := make(map[string]time.Time)
    addFields := func(secs []SectionData) {
        for _, s := range secs {
            for k := range s {
                globalCols.Add(k)
            }
        }
    }
    processV8i := func() (bool, error) {
        changed := false
        files, err := filepath.Glob(inputMask)
        if err != nil {
            return false, err
        }
        temp := []SectionData{}
        for _, path := range files {
            info, err := os.Stat(path)
            if err != nil {
                fmt.Printf("Warn stat %s: %v\n", path, err)
                continue
            }
            last, seen := modV8i[path]
            need := !seen || !info.ModTime().Equal(last)
            if need {
                changed = true
            }
            secs, err := parseV8iFile(path)
            if err != nil {
                fmt.Printf("Warn parse %s: %v\n", path, err)
                continue
            }
            for _, s := range secs {
                s["source_file"] = filepath.Base(path)
            }
            temp = append(temp, secs...)
            addFields(secs)
            if need {
                modV8i[path] = info.ModTime()
            }
        }
        if changed {
            allSections = temp
        }
        return changed, nil
    }
    writeV8i := func() error {
        f, err := os.Create(outCsv)
        if err != nil {
            return err
        }
        defer f.Close()
        w := csv.NewWriter(f)
        defer w.Flush()
        cols := globalCols.Items()
        for i := 1; i < len(cols); i++ {
            if cols[i] == "name" {
                cols[0], cols[i] = cols[i], cols[0]
                break
            }
        }
        w.Write(cols)
        for _, sec := range allSections {
            row := make([]string, len(cols))
            for i, c := range cols {
                row[i] = sec[c]
            }
            w.Write(row)
        }
        return nil
    }

    // Главный цикл: и .v8i и .lgf
    for {
        // .lgf
        if lgfMask != "" && lgfOutCsv != "" {
            if err := processLGF(lgfMask, lgfOutCsv); err != nil {
                fmt.Fprintf(os.Stderr, "Error LGF: %v\n", err)
            } else {
                fmt.Printf("Wrote LGF CSV: %s\n", lgfOutCsv)
            }
        }
        // .v8i
        if inputMask != "" && outCsv != "" {
            if changed, err := processV8i(); err != nil {
                fmt.Fprintf(os.Stderr, "Error V8I: %v\n", err)
            } else if changed {
                if err := writeV8i(); err != nil {
                    fmt.Fprintf(os.Stderr, "Error write V8I CSV: %v\n", err)
                } else {
                    fmt.Printf("Wrote V8I CSV: %s\n", outCsv)
                }
            }
        }
        if interval <= 0 {
            break
        }
        time.Sleep(time.Duration(interval) * time.Second)
    }
}
package main

import (
    "bufio"
    "encoding/csv"
    "errors"
    "flag"
    "fmt"
    "os"
    "path/filepath"
    "strings"
    "time"
)

type SectionData map[string]string

type FileData struct {
    Sections []SectionData
}

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

// Парсит соединение Connect=Srvr="host";Ref="ref" или Connect=File="..."
func parseComplexField(mainKey, value string) map[string]string {
    result := make(map[string]string)
    prefix := mainKey + "_"

    entries := strings.Split(value, ";")
    for _, entry := range entries {
        entry = strings.TrimSpace(entry)
        if entry == "" {
            continue
        }
        kv := strings.SplitN(entry, "=", 2)
        if len(kv) == 2 {
            k := prefix + kv[0]
            v := kv[1]
            v = strings.Trim(v, `"`)
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
    var currentSection SectionData
    var dataSections []SectionData

    for scanner.Scan() {
        line := scanner.Text()
        line = strings.TrimSpace(line)
        line = strings.TrimLeft(line, "\ufeff")
        if line == "" || strings.HasPrefix(line, ";") {
            continue
        }
        if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
            if currentSection != nil && len(currentSection) > 0 {
                dataSections = append(dataSections, currentSection)
            }
            currentSection = make(SectionData)
            sectionName := line[1 : len(line)-1]
            currentSection["name"] = sectionName
        } else if currentSection != nil {
            parts := strings.SplitN(line, "=", 2)
            if len(parts) == 2 {
                k := strings.TrimSpace(parts[0])
                v := strings.TrimSpace(parts[1])
                if strings.Contains(v, ";") && (strings.HasPrefix(v, "Srvr=") || strings.HasPrefix(v, "File=") || strings.HasPrefix(v, "Ref=")) {
                    complexMap := parseComplexField(k, v)
                    for sk, sv := range complexMap {
                        currentSection[sk] = sv
                    }
                    currentSection[k] = v // сохраняем оригинальное поле тоже
                } else {
                    currentSection[k] = v
                }
            }
        }
    }
    if currentSection != nil && len(currentSection) > 0 {
        dataSections = append(dataSections, currentSection)
    }

    if len(dataSections) == 0 {
        return nil, errors.New("no sections found in " + path)
    }
    return dataSections, nil
}

func main() {
    var inputMask, outCsv string
    var interval int

    flag.StringVar(&inputMask, "input", "", "glob pattern for v8i files (required)")
    flag.StringVar(&outCsv, "out", "", "output csv file (required)")
    flag.IntVar(&interval, "interval", 0, "seconds to wait between scans (0=run once)")
    flag.Parse()

    if inputMask == "" || outCsv == "" {
        fmt.Println("Use: --input \"mask\" --out \"result.csv\" [--interval N]")
        os.Exit(1)
    }

    // Сохраняем хедер общий для всех файлов
    globalCols := NewOrderedSet()
    var allSections []SectionData
    modTimes := make(map[string]time.Time)

    // Построение набора полей (ключей)
    getFields := func(sections []SectionData) {
        for _, sec := range sections {
            for k := range sec {
                globalCols.Add(k)
            }
        }
    }

    processFiles := func() (bool, error) {
        changed := false
        files, err := filepath.Glob(inputMask)
        if err != nil {
            return false, err
        }
        // Сбор новых секций
        tempSections := []SectionData{}

        //tempCols := NewOrderedSet()
        filesParsed := 0
        for _, path := range files {
            info, err := os.Stat(path)
            if err != nil {
                fmt.Printf("Warn: cannot stat %s: %v\n", path, err)
                continue
            }
            lastMod, found := modTimes[path]
            needParse := !found || info.ModTime() != lastMod

            if needParse {
                changed = true
            }
            // Всегда добавляем новые/обновлённые секции в формируемый список
            if needParse {
                sections, err := parseV8iFile(path)
                if err != nil {
                    fmt.Printf("Warn: error parsing %s: %v\n", path, err)
                    continue
                }
                for _, sec := range sections {
                    // Добавим инфу о файле, если нужно (например, file_name)
                    sec["source_file"] = filepath.Base(path)
                }
                tempSections = append(tempSections, sections...)
                getFields(sections)
                filesParsed++
                modTimes[path] = info.ModTime()
            } else {
                // Для файлов, которые не изменялись
                // (Чтобы пересобрать единый массив, если их много)
                sections, err := parseV8iFile(path)
                if err != nil {
                    fmt.Printf("Warn: error parsing %s: %v\n", path, err)
                    continue
                }
                for _, sec := range sections {
                    sec["source_file"] = filepath.Base(path)
                }
                tempSections = append(tempSections, sections...)
                getFields(sections)
            }
        }

        if filesParsed > 0 || changed {
            allSections = tempSections
            return true, nil
        }
        return changed, nil
    }

    writeCSV := func() error {
        f, err := os.Create(outCsv)
        if err != nil {
            return err
        }
        defer f.Close()
        w := csv.NewWriter(f)
        defer w.Flush()

        cols := globalCols.Items()

        // name — всегда первым, если есть
        for i := 1; i < len(cols); i++ {
            if cols[i] == "name" {
                cols[0], cols[i] = cols[i], cols[0]
                break
            }
        }

        if err := w.Write(cols); err != nil {
            return err
        }

        for _, sec := range allSections {
            row := make([]string, len(cols))
            for j, k := range cols {
                row[j] = sec[k]
            }
            if err := w.Write(row); err != nil {
                return err
            }
        }
        return nil
    }

    for {
        changed, err := processFiles()
        if err != nil {
            fmt.Printf("Error: %v\n", err)
            os.Exit(1)
        }

        if changed {
            if err := writeCSV(); err != nil {
                fmt.Printf("Failed to write CSV: %v\n", err)
                os.Exit(2)
            }
            fmt.Printf("Wrote merged csv: %s\n", outCsv)
        }

        if interval <= 0 {
            break
        }
        time.Sleep(time.Duration(interval) * time.Second)
    }
}
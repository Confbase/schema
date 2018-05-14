package translate

import (
	"fmt"
	"io"
	"os"

	"github.com/Confbase/schema/util"
)

func TranslateEntry(cfg Config, args []string) {
	if len(args) == 0 {
		if err := Translate(os.Stdin, os.Stdout, cfg); err != nil {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
	} else {
		fmt.Fprintf(os.Stderr, "error: not implemented yet\n")
		os.Exit(1)
	}
}

func Translate(r io.Reader, w io.Writer, cfg Config) error {
	m, err := util.MuxDecode(r)
	if err != nil {
		return err
	}
	if !isAllKeysStrs(m) {
		// TODO: fix this horrible hack
		interMap := make(map[interface{}]interface{})
		for k, v := range m {
			interMap[k] = v
		}
		goodM, err := mkKeysStrsMap(interMap)
		if err != nil {
			return err
		}
		return util.DemuxEncode(w, goodM, cfg.OutFmt(), cfg.DoPretty)
	}
	return util.DemuxEncode(w, m, cfg.OutFmt(), cfg.DoPretty)
}

func isAllKeysStrs(some interface{}) bool {
	xs, ok := some.([]interface{})
	if ok {
		for _, value := range xs {
			switch v := value.(type) {

			case map[interface{}]interface{}:
				for subK, subV := range v {
					_, isStr := subK.(string)
					if !isStr || !isAllKeysStrs(subV) {
						return false
					}
				}

			case []interface{}:
				if !isAllKeysStrs(v) {
					return false
				}
			default:
				continue
			}
		}
		return true
	}

	// TODO: use code generation or somehow de-duplicate this
	m, ok := some.(map[interface{}]interface{})
	if ok {
		for _, value := range m {
			switch v := value.(type) {

			case map[interface{}]interface{}:
				for subK, subV := range v {
					_, isStr := subK.(string)
					if !isStr || !isAllKeysStrs(subV) {
						return false
					}
				}

			case []interface{}:
				if !isAllKeysStrs(v) {
					return false
				}
			default:
				continue
			}
		}
		return true
	}
	return false
}

func mkKeysStrsMap(m map[interface{}]interface{}) (map[string]interface{}, error) {
	res := make(map[string]interface{})
	for key, value := range m {
		keyStr, ok := key.(string)
		if !ok {
			return nil, fmt.Errorf("found non-str key in object")
		}
		switch v := value.(type) {
		case map[interface{}]interface{}:
			strMap, err := mkKeysStrsMap(v)
			if err != nil {
				return nil, err
			}
			res[keyStr] = strMap
		case []interface{}:
			goodSlice, err := mkKeysStrsSlice(v)
			if err != nil {
				return nil, err
			}
			res[keyStr] = goodSlice
		default:
			res[keyStr] = value
		}
	}
	return res, nil
}

func mkKeysStrsSlice(xs []interface{}) ([]interface{}, error) {
	res := make([]interface{}, 0)
	for _, elem := range xs {
		switch v := elem.(type) {
		case map[interface{}]interface{}:
			strMap, err := mkKeysStrsMap(v)
			if err != nil {
				return nil, err
			}
			res = append(res, strMap)
		case []interface{}:
			goodSlice, err := mkKeysStrsSlice(v)
			if err != nil {
				return nil, err
			}
			res = append(res, goodSlice)
		default:
			res = append(res, v)
		}
	}
	return res, nil
}

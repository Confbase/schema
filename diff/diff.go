package diff

import (
	"fmt"
	"os"
	"reflect"

	"github.com/Confbase/schema/decode"
	"github.com/Confbase/schema/example"
	"github.com/Confbase/schema/jsonsch"
)

func Diff(s1, s2 jsonsch.Schema) ([]Difference, error) {
	return diff(s1, s2, "")
}

func diff(s1, s2 jsonsch.Schema, parentKey string) ([]Difference, error) {
	const (
		schemaOneName = "the first schema"
		schemaTwoName = "the second schema"
	)

	s1Props, s2Props := s1.GetProperties(), s2.GetProperties()
	s1Diffs, err := diffPropsFrom(s1Props, s2Props, schemaTwoName)
	if err != nil {
		return nil, err
	}
	s2Diffs, err := diffPropsFrom(s2Props, s1Props, schemaOneName)
	if err != nil {
		return nil, err
	}

	// differingTypes is the set of fields which have differing types.
	// Any DifferyingType found in s1 is guaranteed
	// to be in s2, but we ony want one of these instances
	// in the returned diffs.
	diffs, differingTypes := filterUniqueDiffs(s1Diffs, make(map[string]bool))
	diffs2, _ := filterUniqueDiffs(s2Diffs, differingTypes)

	return append(diffs, diffs2...), nil
}

func filterUniqueDiffs(newDiffs []Difference, differingTypes map[string]bool) ([]Difference, map[string]bool) {
	diffs := make([]Difference, 0)
	for _, d := range newDiffs {
		if _, ok := d.(*DifferingTypes); ok {
			field := d.getField()
			if _, ok := differingTypes[field]; !ok {
				diffs = append(diffs, d)
				differingTypes[field] = true
			}
		} else {
			diffs = append(diffs, d)
		}
	}
	return diffs, differingTypes
}

// diffPropsFrom assumes props1 is the base. It will return
// 1. all DifferingTypes differences
// 2. all fields which are in props1 but missing from props2
//
// Therefore, to do a complete diff of props1 and props2,
// one must call
// diffPropsFrom(props1, props2) AND diffPropsFrom(props2, props1)
// and merge the results
func diffPropsFrom(props1, props2 map[string]interface{}, missingFrom string) ([]Difference, error) {
	diffs := make([]Difference, 0)
	for k, v1 := range props1 {
		v2, ok := props2[k]
		if !ok {
			diffs = append(diffs, &MissingField{k, missingFrom})
			continue
		}
		var type1, type2 string
		var as1, as2 jsonsch.ArraySchema

		resolvedV1, ok := v1.(map[string]interface{})
		if ok {
			t, ok := resolvedV1["type"]
			if !ok {
				return nil, fmt.Errorf("key '%v' has no 'type' field", k)
			}
			type1, ok = t.(string)
			if !ok {
				return nil, fmt.Errorf("key '%v' has 'type' field, but it's not a string", k)
			}
		} else {
			as1, ok = v1.(jsonsch.ArraySchema)
			if !ok {
				return nil, fmt.Errorf("key '%v' has unrecognized type '%v'", k, reflect.TypeOf(v1))
			}
			type1 = string(as1.Type)
		}
		resolvedV2, ok := v2.(map[string]interface{})
		if ok {
			t, ok := resolvedV2["type"]
			if !ok {
				return nil, fmt.Errorf("key '%v' has no 'type' field", k)
			}
			type2, ok = t.(string)
			if !ok {
				return nil, fmt.Errorf("key '%v' has 'type' field, but it's not a string", k)
			}
		} else {
			as2, ok = v2.(jsonsch.ArraySchema)
			if !ok {
				return nil, fmt.Errorf("key '%v' has unrecognized type '%v'", k, reflect.TypeOf(v2))
			}
			type2 = string(as2.Type)
		}
		if type1 != type2 {
			diffs = append(diffs, &DifferingTypes{k})
			continue
		}
		var s1, s2 jsonsch.Schema
		if type1 == string(jsonsch.Array) {
			s1, ok = as1.Items.(jsonsch.Schema)
			if !ok {
				return nil, fmt.Errorf("in the first schema, the key '%v' is an array but its 'items' field is not a JSON Schema object, %T", k)
			}
			s2, ok = as2.Items.(jsonsch.Schema)
			if !ok {
				return nil, fmt.Errorf("in the second schema, the key '%v' is an array but its 'items' field is not a JSON Schema object", k)
			}
		} else if type1 == string(jsonsch.Object) {
			var err error
			s1, err = jsonsch.FromSchema(resolvedV1, false, true)
			if err != nil {
				return nil, err
			}
			s2, err = jsonsch.FromSchema(resolvedV2, false, true)
			if err != nil {
				return nil, err
			}
		} else {
			continue
		}
		subDiffs, err := Diff(s1, s2)
		if err != nil {
			return nil, err
		}
		for _, d := range subDiffs {
			prependKey(d, k)
			diffs = append(diffs, d)
		}

	}
	return diffs, nil
}

func nilOrFatal(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func Entry(cfg *Config) {
	f1, err := os.Open(cfg.Schema1)
	nilOrFatal(err)
	f2, err := os.Open(cfg.Schema2)
	nilOrFatal(err)

	map1, err := decode.MuxDecode(f1)
	nilOrFatal(err)
	f1.Close()
	map2, err := decode.MuxDecode(f2)
	nilOrFatal(err)
	f2.Close()

	s1, err := jsonsch.FromSchema(map1, false, cfg.DoSkipRefs)
	if err != nil {
		params := jsonsch.FromExampleParams{
			DoOmitReq:     false,
			DoMakeReq:     true,
			EmptyArraysAs: "",
			NullAs:        "",
		}
		s1, err = jsonsch.FromExample(example.New(map1), &params)
		nilOrFatal(err)
	}
	s2, err := jsonsch.FromSchema(map2, false, cfg.DoSkipRefs)
	if err != nil {
		params := jsonsch.FromExampleParams{
			DoOmitReq:     false,
			DoMakeReq:     true,
			EmptyArraysAs: "",
			NullAs:        "",
		}
		s2, err = jsonsch.FromExample(example.New(map2), &params)
		nilOrFatal(err)
	}

	diffs, err := Diff(s1, s2)
	nilOrFatal(err)

	for _, d := range diffs {
		fmt.Println(d)
	}
}

package diff

import "fmt"

type Difference interface {
	String() string
	setField(string)
	getField() string
}

func prependKey(d Difference, k string) {
	if k == "" {
		return
	}
	d.setField(fmt.Sprintf("%v.%v", k, d.getField()))
}

type MissingField struct {
	field string
	from  string
}

func (m *MissingField) String() string {
	return fmt.Sprintf("the field '%v' is missing from %v", m.field, m.from)
}

func (m *MissingField) setField(field string) {
	m.field = field
}

func (m *MissingField) getField() string {
	return m.field
}

type DifferingTypes struct {
	field string
}

func (d *DifferingTypes) String() string {
	return fmt.Sprintf("the field '%v' has differing types", d.field)
}

func (d *DifferingTypes) setField(field string) {
	d.field = field
}

func (d *DifferingTypes) getField() string {
	return d.field
}

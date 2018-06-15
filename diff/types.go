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
	field  string
	title1 string
	title2 string
}

func (d *DifferingTypes) String() string {
	return fmt.Sprintf("the field '%v' has differing types between %v and %v", d.field, d.title1, d.title2)
}

func (d *DifferingTypes) setField(field string) {
	d.field = field
}

func (d *DifferingTypes) getField() string {
	return d.field
}

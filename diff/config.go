package diff

type Config struct {
	Schema1    string
	Schema2    string
	DoSkipRefs bool
	MissFrom1  string
	MissFrom2  string
}

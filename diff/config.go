package diff

type Config struct {
	Schema1    string
	Schema2    string
	DoSkipRefs bool
	titleStrings
}

type titleStrings struct {
	Title1, Title2       string
	MissFrom1, MissFrom2 string
	Differ1, Differ2     string
}

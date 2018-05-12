package translate

type Config struct {
	InputPath  string
	DoJson     bool
	DoYaml     bool
	DoToml     bool
	DoXml      bool
	DoProtobuf bool
	DoGraphQL  bool
	DoPretty   bool
}

func (translate *Config) OutFmt() string {
	if translate.DoJson {
		return "json"
	}
	if translate.DoYaml {
		return "yaml"
	}
	if translate.DoToml {
		return "toml"
	}
	if translate.DoXml {
		return "xml"
	}
	if translate.DoProtobuf {
		return "protobuf"
	}
	if translate.DoGraphQL {
		return "graphql"
	}
	return "json"
}

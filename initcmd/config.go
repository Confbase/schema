package initcmd

type Config struct {
	SchemaPath string
	DoJson     bool
	DoYaml     bool
	DoToml     bool
	DoXml      bool
	DoProtobuf bool
	DoGraphQL  bool
	DoPretty   bool
	DoPopLists bool
	DoSkipRefs bool
}

func (cfg *Config) OutFmt() string {
	if cfg.DoJson {
		return "json"
	}
	if cfg.DoYaml {
		return "yaml"
	}
	if cfg.DoToml {
		return "toml"
	}
	if cfg.DoXml {
		return "xml"
	}
	if cfg.DoProtobuf {
		return "protobuf"
	}
	if cfg.DoGraphQL {
		return "graphql"
	}
	return "json"
}

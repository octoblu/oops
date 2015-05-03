package config

// Config stores .oopsrc values
type Config struct {
	ApplicationName string
	DeploymentGroup string
	ElbName         string
	S3Bucket        string
}

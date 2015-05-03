package config

import (
	"encoding/json"
	"io/ioutil"
)

// ParseConfig parses the passed in config file
// and returns a struct with standard deployment
// information
func ParseConfig() (Config, error) {
	var config Config

	rawJSON, err := ioutil.ReadFile(".oopsrc")
	if err != nil {
		return config, err
	}

	var dat map[string]interface{}

	if err := json.Unmarshal(rawJSON, &dat); err != nil {
		return config, err
	}

	config.ApplicationName = dat["application-name"].(string)
	config.DeploymentGroup = dat["deployment-group"].(string)
	config.ElbName = dat["elb-name"].(string)
	config.S3Bucket = dat["s3-bucket"].(string)

	return config, nil
}

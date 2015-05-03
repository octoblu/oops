package commands

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"

	"github.com/codegangsta/cli"
	"github.com/mitchellh/goamz/aws"
	"github.com/mitchellh/goamz/s3"
)

// Config stores .oopsrc values
type Config struct {
	applicationName string
	deploymentGroup string
	elbName         string
	s3Bucket        string
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func parseConfig() (Config, error) {
	var config Config

	rawJSON, err := ioutil.ReadFile(".oopsrc")
	if err != nil {
		return config, err
	}

	var dat map[string]interface{}

	if err := json.Unmarshal(rawJSON, &dat); err != nil {
		return config, err
	}

	config.applicationName = dat["application-name"].(string)
	config.deploymentGroup = dat["deployment-group"].(string)
	config.elbName = dat["elb-name"].(string)
	config.s3Bucket = dat["s3-bucket"].(string)

	return config, nil
}

// List lists out available code deploy packages
func List(c *cli.Context) {
	config, err := parseConfig()
	check(err)

	auth, err := aws.SharedAuth()
	check(err)

	client := s3.New(auth, aws.USWest2)
	resp, err := client.ListBuckets()
	check(err)

	for _, bucket := range resp.Buckets {
		if bucket.Name == config.s3Bucket {
			log.Print(fmt.Sprintf("%T %+v", bucket, bucket))
		}
	}
}

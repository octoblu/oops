package commands

import (
	"fmt"
	"log"

	"github.com/codegangsta/cli"
	"github.com/octoblu/oops/config"
	"github.com/octoblu/oops/deploy"
)

func check(e error) {
	if e != nil {
		log.Fatal(e)
	}
}

// List lists out available code deploy packages
func List(c *cli.Context) {
	config, err := config.ParseConfig()
	check(err)

	deployments, err := deploy.GetDeployments(config.S3Bucket, config.ApplicationName)
	check(err)

	for _, deployment := range deployments {
		fmt.Println(deployment)
	}
}

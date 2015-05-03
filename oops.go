package main

import (
	"os"

	"github.com/codegangsta/cli"
	"github.com/octoblu/oops/commands"
)

func main() {
	app := cli.NewApp()
	app.Name = "oops"
	app.Version = "0.0.0"
	app.Usage = "Undo deploys, keep your job."
	app.EnableBashCompletion = true

	app.Commands = []cli.Command{
		{
			Name:    "list",
			Aliases: []string{"l"},
			Usage:   "List available deploys to rollback to.",
			Action:  commands.List,
		},
	}

	app.Run(os.Args)
}

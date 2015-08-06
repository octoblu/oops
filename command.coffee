_ = require 'lodash'
fs = require 'fs'
path = require 'path'
colors = require 'colors'
{exec} = require 'child_process'
commander   = require 'commander'
packageJSON = require './package.json'

class Command
  run: =>
    commander
      .usage 'command'
      .parse process.argv

    command = _.first commander.args

    unless command?
      commander.outputHelp()
      process.exit 1

    if fs.existsSync('./.oopsrc')
      oopsrc = JSON.parse fs.readFileSync('.oopsrc')
      project_name = oopsrc['application-name']

    project_name ?= path.basename process.cwd()

    exec "t1000 #{command} #{project_name} --color=always", (error, stdout, stderr) =>
      console.error error.message if error?
      console.log stdout if stdout?
      console.error stderr if stderr?

(new Command()).run()

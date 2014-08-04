fs = require 'fs'

{print} = require 'sys'
{exec} = require 'child_process'

build = (callback) ->
  coffee = exec 'coffee -c lib/'
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    browserify = exec 'browserify ./lib/app.js -o ./app.min.js --bare -d'
    browserify.stderr.on 'data', (data) ->
    	process.stderr.write data.toString()
    browserify.stdout.on 'data', (data) ->
      print data.toString()


    callback?() if code is 0

task 'sbuild', 'Build Lib/', ->
  build()

task 'build', 'Build Lib/', ->
  build()
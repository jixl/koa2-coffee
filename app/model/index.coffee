'use strict'
mongo = exports? and exports

lib = require('../lib')
myutil = require('myutil')

conf =
  url : 'mongodb://localhost:27017/test'
  # opts: {}
mongoose = lib.mongoose conf

path = "#{__dirname}"
myutil.loadFiles 'index.coffee', path, (filename) ->
  klass = require(filename)(mongoose)
  mongo[klass.name] = klass if klass.name
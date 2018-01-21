'use strict'

assert = require('assert')
mongoose = require('mongoose')
EventEmitter = require('events')

logger = console

module.exports = (conf) ->
  assert(conf.url, '[lib-mongoose] url is required on config')

  mongoose.Promise = global.Promise
  mongoose.set 'debug', true
  
  # mongoose.connect('mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]' [, options])
  # conf.opts.useMongoClient = true
  # mongoose.connect conf.url, conf.opts
  # db = mongoose.connection

  db = mongoose.createConnection conf.url, conf.opts
  db.Schema = mongoose.Schema

  logger.info('[lib-mongoose] start connecting...')

  heartEvent = new EventEmitter()
  heartEvent.on 'connected', ()->
    logger.info('[lib-mongoose] start successfully and server status is ok')

  db.on 'error', (err) ->
    err.message = "[lib-mongoose]#{err.message}"
    logger.error(err)

  db.on 'disconnected', () ->
    logger.error("[lib-mongoose] #{conf.url} disconnected")

  db.on 'connected', () ->
    heartEvent.emit('connected')
    logger.info("[lib-mongoose] #{conf.url} connected successfully")

  db.on 'reconnected', () ->
    logger.info("[lib-mongoose] #{conf.url} reconnected successfully")

  db

'use strict'
ErrorHandler = require './error'

module.exports = (app) ->
  app.use ErrorHandler
  # x-response-time
  app.use (ctx, next) ->
    start = Date.now()
    await next()
    ms = Date.now() - start
    ctx.set 'X-Response-Time', "#{ms}ms"

  # logger
  app.use (ctx, next) ->
    start = Date.now()
    await next()
    ms = Date.now() - start
    console.log "#{ctx.method} #{ctx.url} - #{ms}"

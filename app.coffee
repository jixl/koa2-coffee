'use strict'
koa = require('koa')
app = new koa()

require('./app/middleware')(app)

router = require './app/router.coffee'
app.use router.routes()

app.listen 3000, (err)->
  console.log "server start #{err or 'success'}"
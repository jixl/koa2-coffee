'use strict'

module.exports = (ctx, next) ->
  try
    await next()
  catch err
    console.log err
    ctx.status = err.statusCode or err.status or 500
    ctx.body = { message: err.message }

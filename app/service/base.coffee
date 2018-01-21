'use strict'

myutil = require 'myutil'

class BaseService
  constructor : (@user, @ctx, @op)->
    @param = {} if not @ctx.query
 
  checkPrev : -> true
 
  handleError : (status, msg, data)->
    @ctx.throw status, msg, data
    # ctx.throw(400, 'name required', { user: user })
 
  handleOK : (data)->
    @ctx.body = data
 
  run : ->
    if @checkPrev()
      @_run()
    else
      @handleError({error: 'NoPrev!'}, 401, 401)
 
  _run : ->
    fn = @[@op]
    if fn and myutil.isFunction fn
      fn.apply @
    else
      @handleError({error: "No Method #{@op} !"}, 402, 402)
 
  _cb : (err, result) =>
    if not err
      @handleOK(result)
    else
      status = result?.status ? 501
      @handleError(status, 'error', {error:err, info:result})
 
 
module.exports = BaseService
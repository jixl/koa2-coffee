'use strict'

myutil = require 'myutil'
Router = require 'koa-router'
service = require './service'

router = new Router()

dispatcher = (req)->
  path = myutil.getpath req
  rps = path.split('/')

  length = rps.length
  controller = {cls:null, op:null}
  return controller if length < 3
  key = rps[length - 2]
  controller.op = rps[length - 1]
  if servicesTbl[key]
    controller.cls = servicesTbl[key]
  controller
 
servicesTbl =
  'user' : service.UserService
 
router.all '*', (ctx, next)->
  data = {}
  ctrl = dispatcher ctx.request
  if ctrl.cls
    obj = new ctrl.cls(data, ctx, ctrl.op)
    obj.run()
  else
    ctx.body {status: 1001, info: '接口访问调用异常，请联系管理员'}

module.exports = router
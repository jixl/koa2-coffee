# koa2-coffee 一个基于coffee + mongoose + koa2 的服务端项目框架demo

## 目录

- [基础环境配置](#基础环境)
- [项目搭建](#项目搭建)
- [数据库配置](#数据库配置)
- [创建数据库模型](#创建数据库模型)
- [创建子路由文件](#创建子路由文件)
- [路由配置](#路由配置)
- [接口测试](#接口测试)

---
## 基础环境配置
### 服务器环境配置

##### [**Node.js环境**](https://nodejs.org/zh-cn/)

```
$ node -v
v8.9.4
```
#### 数据库环境 [**MongoDB 安装**](https://www.mongodb.com/)

---
## 项目搭建
- 新建文件夹kcm-demo
- 创建入口文件`app.coffee`
- 创建[***package.json文件***](https://docs.npmjs.com/files/package.json)。（`package.json`文件可以手工编写，也可以使用`npm init`命令自动生成，输入名字和`main`文件`index.coffee`，注意名字不能大写，其余按回车自动生成）。

```
//到项目根目录下  
$ cd kcpDemo
$ npm init  
```

生成的`package.json`文件如下:

```json
{
  "name": "kcm-demo",
  "version": "1.0.0",
  "description": "",
  "main": "app.coffee",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}
```

- 添加依赖 [**koa2**](http://koajs.com/) [**mongoose**](http://docs.sequelizejs.com/) [**mongoose**](http://docs.sequelizejs.com/)

```
$ npm install --save koa mongoose coffeescript
```

- 在`app.coffee`文件中创建启动代码

```coffee
koa = require("koa")
app = new koa()

app.use (ctx)->
  ctx.body = "hello koa2"

app.listen 3000,(err)->
  console.log("server start #{err or "success"}")
```

- 启动服务

```
//根目录下启动项目
$ coffee index.coffee
server start success
```

- 测试

```shell
$ http :3000
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 10
Content-Type: text/plain; charset=utf-8
Date: Sat, 12 Aug 2017 01:14:01 GMT

hello koa2
```
可以看到成功输出 `hello koa2`，服务创建成功。

## 数据库配置
以上只是一个简单的hello word服务程序，并没有与数据库有任何关系，下面来配置数据库。
- 创建 `app/lib/mongoose.coffee` 文件连接数据库
```coffee
'use strict'

assert = require('assert')
mongoose = require('mongoose')
EventEmitter = require('events')

logger = console

module.exports = (conf) ->
  assert(conf.url, '[lib-mongoose] url is required on config')

  mongoose.Promise = global.Promise
  mongoose.set 'debug', true
  
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
```
- 创建 `app/lib/index.coffee`文件，并导出mongoose.coffee模块

```coffee
'use strict'

module.exports.mongoose = require('../lib/mongoose')
```

- 在 `app.coffee` 文件中引入数据为初始化模块

```coffee
koa = require("koa")
app = new koa()

conf = 
  url: 'mongodb://localhost:27017/test'
require('./app/lib').mongoose conf

app.use (ctx)->
  ctx.body = "hello koa2"

app.listen 3000,(err)->
  console.log("server start #{err or "success"}")
```

- 重新启动服务
```sh
$ coffee app.coffee
[lib-mongoose] start connecting...
server start success
[lib-mongoose] start successfully and server status is ok
[lib-mongoose] mongodb://localhost:27017/test connected successfully
```

- 定义mongoose schema `app/model/user.coffee` 模型

```coffee
'use strict'

_collection = 'user'
module.exports = (mongoose)->
  schema =
    name: String
    age: Number
    address: String

  # schema = new mongoose.Schema sdef
  model = mongoose.model _collection, schema
```

- 创建 `app/model/index.coffee` 文件,并导出模型定义

```coffee
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
```

### 服务配置
- 创建统一处理服务`app/service/base.coffee`
```coffee
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
```
- 创建 `userService: app/service/user.coffee` 

```coffee
'use strict'

{ User } = require '../model'
BaseService = require './base'

class UserService extends BaseService
  
  list: ->
    new User().find {}, @_cb

module.exports = UserService
```

- 创建Service模块统一导出文件`app/service/index.coffee`

```coffee
'use strict'
service = exports? and exports

service.UserService = require './user.coffee'
```

## 路由配置
- 定义统一路由处理
```coffee
'use strict'

myutil = require 'myutil'
Router = require 'koa-router'
service = require './service'

router = new Router()

# 可以自定义路由的实现，而无需引入koa-router路由
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
```

- 在入口文件`app.coffee`配置路由

```coffee
koa = require("koa")
app = new koa()
Router = require("koa-router")
bodyParser = require("koa-bodyparser")

#koa-body-parser初始化
app.use bodyParser()

#创建一个路由
router = new Router prefix:'/api'

#子路由
user = require("./apis/user")
#装载子路由
router.use user.routes(),user.allowedMethods()

#加载路由中间件
app.use router.routes()

app.use (ctx)->
  ctx.body = "hello koa2"


require("./lib")

app.listen 3000,(err)->
  console.log("server start #{err or "success"}")
```

## 接口测试

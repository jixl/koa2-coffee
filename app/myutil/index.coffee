'use strict'
myutil = exports? and exports

fs = require 'fs'
R = require 'ramda'

String::trim = -> @replace(/^\s+/g,"").replace(/\s+$/g,"")
String::fmt = ()-> @trim().toLocaleLowerCase()

myutil.getpath = (req) -> req.url.fmt()

myutil.isNumber = (v)-> 'Number' is R.type v
myutil.isObject = (v)-> 'Object' is R.type v
myutil.isBoolean = (v)-> 'Boolean' is R.type v
myutil.isString = (v)-> 'String' is R.type v
myutil.isNull = (v)-> 'Null' is R.type v
myutil.isArray = (v)-> 'Array' is R.type v
myutil.isRegExp = (v)-> 'RegExp' is R.type v
myutil.isFunction = (v)-> 'Function' is R.type v

_isObject = (x) -> Object::toString.call(x) is '[object Object]'
###
  @description 检查判断是否空
  @param {*} v 需要检查的对象
  @return {Boolean} 空 true 0 | '' | null | undefined | [] | {}, 非空 false
###
myutil.isEmpty = (v) ->
  !v or (Array.isArray(v) and v.length is 0) or (_isObject(v) and Object.keys(v).length is 0)

myutil.loadFiles = (self, path, fn)->
  _isntLoad = (filename)->
    pos = filename.lastIndexOf('.')
    return if pos is -1

    filePrefix = filename.substr(0, pos)
    filePostfix = filename.substr(pos + 1)
    return filePrefix.length < 1 or filePostfix.length < 1 or filePostfix isnt 'coffee'

  fs.readdirSync(path).forEach (filename)->
    return if self is filename
    return if _isntLoad filename
    fn "#{path}/#{filename}"


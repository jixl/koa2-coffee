'use strict'

#访问数据库基础服务。
class MongoBase
  constructor : (@model) ->

  update : (args..., cb) ->
    @_run 'update', args, cb
 
  findById : (id, cb) ->
    projection = null
    option = {lean: true}
    args = [id, projection, option]
    @_run 'findById', args, cb
 
  _run : (method, args, cb) =>
    args.push cb
    @model[method].apply @model, args
 
  create: (doc, cb) ->
    @_run 'create', [doc], cb
 
  remove: (id, cb) ->
    args = [id]
    @_run 'findByIdAndRemove', args, cb
 
  find: (query, projection, options, cb) ->
    if typeof projection is 'function'
      cb = projection
      projection = null
      # options = null
      options = {lean: true} # high performance
    else if typeof options is 'function'
      cb = options
      options = {lean: true}
    else
      options.lean = true

    @_run 'find', [query, projection, options], cb
 
  count: (query, cb) ->
    @_run 'count', [query], cb
 
  findOneAndUpdate: (id, update, cb) ->
    @_run 'findOneAndUpdate', [id, update], cb
 
  findOne: (query, projection, cb) ->
    if typeof projection is 'function'
      cb = projection
      projection = null
    option = {lean: true}
    @_run 'findOne', [query, projection, option], cb

module.exports = MongoBase

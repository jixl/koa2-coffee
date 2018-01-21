'use strict'

{ User } = require '../model'
BaseService = require './base'

class UserService extends BaseService
  
  list: ->
    new User().find {}, @_cb

module.exports = UserService
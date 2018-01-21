'use strict'

MongoBase = require '../lib/mongo-base'

_collection = 'user'
module.exports = (mongoose)->
  schema =
    name: String
    age: Number

  # schema = new mongoose.Schema sdef
  model = mongoose.model _collection, schema

  class User extends MongoBase
    constructor : ->
      super model

  User
 
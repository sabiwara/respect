
_ = require 'lodash'

class Comparator

  ###
  METHODS
  ###

  constructor: (@expected, @actual) ->
    @discrepency = []
    @displayActual = {}
    @conform = true
    for key, value of @expected
      @compareKey(key, value)

  compareKey: (key, expected) ->
    actual = @actual[key]
    @displayActual[key] = actual
    if !@compareValues(expected, actual)
      @discrepency.push(key)
      @conform = false

  compareValues: (expected, actual) ->
    if expected?.prototype?.hasOwnProperty('constructor')
      return actual?.constructor == expected
    return _.isEqual expected, actual

  chaiAssert: (ctx) ->
    keyword = @constructor.KEYWORD
    ctx.assert(
      @conform,
      "expected #{'#{this}'} to #{keyword} #{'#{exp}'} but got #{'#{act}'}",
      "expected #{'#{this}'} not to #{keyword} #{'#{exp}'}",
      @expected,
      @displayActual
    )

  shouldAssert: (ctx) ->
    keyword = @constructor.KEYWORD
    ctx.params =
      operator: "to #{ keyword }"
      expected: @expected
    if !@conform
      ctx.fail()

  ###
  STATICS
  ###

  @KEYWORD: 'respect'

  @addToChai: (chaiModule) ->
    ComparatorClass = @
    chaiModule.use (chai, utils) ->
      utils.addMethod chai.Assertion.prototype, ComparatorClass.KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this._obj)
        comparator.chaiAssert(this)
    return chaiModule

  @addToShould: (shouldModule) ->
    ComparatorClass = @
    shouldModule.use (should, Assertion) ->
      Assertion.add ComparatorClass.KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this.obj)
        comparator.shouldAssert(this)
    return shouldModule


module.exports = Comparator
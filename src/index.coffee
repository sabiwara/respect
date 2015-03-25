
_ = require 'lodash'

class Comparator

  KEYWORD: 'respect'

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
    keyword = @KEYWORD
    ctx.assert(
      @conform,
      "expected #{'#{this}'} to #{keyword} #{'#{exp}'} but got #{'#{act}'}",
      "expected #{'#{this}'} not to #{keyword} #{'#{exp}'}",
      @expected,
      @displayActual
    )

  shouldAssert: (ctx) ->
    ctx.params =
      operator: "to #{ @KEYWORD }"
      expected: @expected
    if !@conform
      ctx.fail()

  ###
  STATICS
  ###

  @spawnSubClass: (alias) ->
    class ComparatorClass extends @
    ComparatorClass::KEYWORD = alias if alias
    return ComparatorClass

  @addToChai: (chaiModule, alias) ->
    ComparatorClass = @spawnSubClass alias
    chaiModule.use (chai, utils) ->
      console.log 'chai.should.', ComparatorClass::KEYWORD
      utils.addMethod chai.Assertion.prototype, ComparatorClass::KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this._obj)
        comparator.chaiAssert(this)
    return chaiModule

  @addToShould: (shouldModule, alias) ->
    ComparatorClass = @spawnSubClass alias
    shouldModule.use (should, Assertion) ->
      console.log 'should.', ComparatorClass::KEYWORD
      Assertion.add ComparatorClass::KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this.obj)
        comparator.shouldAssert(this)
    return shouldModule


module.exports = Comparator
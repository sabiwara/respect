
_ = require 'lodash'

class Comparator

  KEYWORD: 'respect'

  ###
  METHODS
  ###

  constructor: (@expected, @actual) ->
    @discrepency = []
    @displayActual = {}
    @conform = yes
    for key, value of @expected
      @compareKey(key, value)

  compareKey: (key, expected) =>
    actual = @actual[key]
    @displayActual[key] = actual
    if !@compareValues(expected, actual)
      @discrepency.push(key)
      @conform = no

  compareValues: (expected, actual) ->
    if _.isEqual expected, actual
      return yes
    if _.isRegExp expected
      return (_.isString actual) and (actual.match expected)
    if expected?.prototype?.hasOwnProperty('constructor')
      return actual?.constructor is expected
    return no

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
      utils.addMethod chai.Assertion.prototype, ComparatorClass::KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this._obj)
        comparator.chaiAssert(this)
    return chaiModule

  @addToShould: (shouldModule, alias) ->
    ComparatorClass = @spawnSubClass alias
    shouldModule.use (should, Assertion) ->
      Assertion.add ComparatorClass::KEYWORD, (expected) ->
        comparator = new ComparatorClass(expected, this.obj)
        comparator.shouldAssert(this)
    return shouldModule


module.exports = Comparator
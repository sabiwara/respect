
_ = require 'lodash'

class Comparator

  KEYWORD: 'respect'

  ###
  METHODS
  ###

  constructor: (@expected, @actual, options={}) ->
    for optionName in ['partial', 'regex', 'types']
      @[optionName] = not (options[optionName] is no)
    @discrepency = []
    @displayActual = {}
    @conform = yes
    @comparePartial()
    if not @partial
      @checkForMissingKeys()

  comparePartial: =>
    for key, value of @expected
      @compareKey(key, value)

  checkForMissingKeys: =>
    for key of @actual when not (key of @expected)
      @compareKey(key, undefined )

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
      utils.addMethod chai.Assertion.prototype, ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this._obj, options)
        comparator.chaiAssert(this)
    return chaiModule

  @addToShould: (shouldModule, alias) ->
    ComparatorClass = @spawnSubClass alias
    shouldModule.use (should, Assertion) ->
      Assertion.add ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this.obj, options)
        comparator.shouldAssert(this)
    return shouldModule


module.exports = Comparator
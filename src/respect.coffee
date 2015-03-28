
Comparator = require './comparator'


class RespectPlugin extends Comparator

  KEYWORD: 'respect'

  chaiAssert: (ctx) ->
    keyword = @KEYWORD
    ctx.assert(
      @conform,
      "expected #{'#{this}'} to #{keyword} #{'#{exp}'}",
      "expected #{'#{this}'} not to #{keyword} #{'#{exp}'} (false negative fail)",
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

  @parseCustom: (custom) ->
    alias = custom?.alias
    options = {}
    for optionName, defaultValue of @DEFAULT_OPTIONS
      options[optionName] = custom?[optionName]
      options[optionName] ?= defaultValue
    return [alias, options]

  @spawnSubClass: (custom) ->
    class ComparatorClass extends @
    [alias, options] = @parseCustom(custom)
    ComparatorClass::KEYWORD = alias if alias
    ComparatorClass.DEFAULT_OPTIONS = options
    return ComparatorClass

  @chaiPlugin: (custom) ->
    (chai, utils) =>
      ComparatorClass = @spawnSubClass custom
      utils.addMethod chai.Assertion.prototype, ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this._obj, options)
        comparator.chaiAssert(this)

  @shouldPlugin: (custom) ->
    (should, Assertion) =>
      ComparatorClass = @spawnSubClass custom
      Assertion.add ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this.obj, options)
        comparator.shouldAssert(this)


module.exports = RespectPlugin

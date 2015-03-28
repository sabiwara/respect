
Comparator = require './comparator'


class RespectPlugin extends Comparator

  KEYWORD: 'respect'

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


module.exports = RespectPlugin

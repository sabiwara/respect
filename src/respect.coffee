###
# respect.js
Comparison plugin for BDD assertion libraries ([chai](http://chaijs.com/),
[should](https://www.npmjs.com/package/should))

###


Comparator = require './comparator'


class AssertionPlugin extends Comparator
  ###
  The actual `respect` object that implements the interface with external BDD assertion libraries
  (**chai**, **should**).
  Can be extended at will to add custom behaviours.
  ###

  ###
  INSTANCE
  ###

  KEYWORD: 'respect'

  chaiAssert: (ctx) ->
    ###
    Defines the content of the assertion method for a comparator within the **chai** plugin for a context `ctx`
    ###
    keyword = @KEYWORD
    ctx.assert(
      @conform,
      "expected #{'#{this}'} to #{keyword} #{'#{exp}'}",
      "expected #{'#{this}'} not to #{keyword} #{'#{exp}'} (false negative fail)",
      @expected,
      @actual
    )

  shouldAssert: (ctx) ->
    ###
    Defines the content of the assertion method for a comparator within the **should** plugin for a context `ctx`
    ###
    ctx.params =
      operator: "to #{ @KEYWORD }"
      expected: @expected
    if !@conform
      ctx.fail()

  ###
  STATICS
  ###

  @parseCustom: (rawOptions) ->
    ###
    Parses the `options` object from `spawnSubClass` into something that can be used to extend into a custom subclass
    ###
    alias = rawOptions?.alias
    options = {}
    for optionName, defaultValue of @DEFAULT_OPTIONS
      options[optionName] = rawOptions?[optionName]
      options[optionName] ?= defaultValue
    return [alias, options]

  @spawnSubClass: (options) =>
    ###
    Dynamically extends the class to use the given options
    ###
    class ComparatorClass extends @
    [alias, options] = @parseCustom(options)
    ComparatorClass::KEYWORD = alias if alias
    ComparatorClass.DEFAULT_OPTIONS = options
    return ComparatorClass

  @chaiPlugin: (options) ->
    ###
    Generates a `AssertionPlugin` subclass and defines a plugin for **chai** that relies on it for assertions
    ###
    (chai, utils) =>
      ComparatorClass = @spawnSubClass options
      utils.addMethod chai.Assertion.prototype, ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this._obj, options)
        comparator.chaiAssert(this)

  @shouldPlugin: (options) ->
    ###
    Generates a `AssertionPlugin` subclass and defines a plugin for **should** that relies on it for assertions
    ###
    (should, Assertion) =>
      ComparatorClass = @spawnSubClass options
      Assertion.add ComparatorClass::KEYWORD, (expected, options) ->
        comparator = new ComparatorClass(expected, this.obj, options)
        comparator.shouldAssert(this)


exports = module.exports = AssertionPlugin

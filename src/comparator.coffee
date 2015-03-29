
_ = require 'lodash/lang'


class Comparator
  ###
  The underlying class handling all comparisons. It is not aware of any assertion library and simply evaluates
  that an `actual` object **respects** an `expected` specification.
  ###

  @DEFAULT_OPTIONS:
    partial: yes
    regex: yes
    types: yes

  constructor: (@expected, @actual, options) ->
    @options = {}
    for optionName, defaultValue of @constructor.DEFAULT_OPTIONS
      @options[optionName] = options?[optionName]
      @options[optionName] ?= defaultValue
    @conform = yes
    do @comparePartial
    if not @options.partial
      do @checkForMissingKeys

  comparePartial: =>
    ###
    Compares only keys that are present in the expected specification
    ###
    if (@expected?) is not (@actual?)
      return @conform = no
    if _.isArray @expected
      if not ((_.isArray @actual) and (@actual.length is @expected.length))
        return @conform = no
    for key, value of @expected when @conform
      @compareKey(key, value)

  checkForMissingKeys: =>
    ###
    Checks keys from the expected specification that are not present in the actual object
    ###
    for key of @actual when not (key of @expected)
      @compareKey key, undefined

  compareKey: (key, expected) =>
    ###
    Checks a key from the actual object regarding to the expected value for that key
    ###
    actual = @actual[key]
    if !@compareValues(expected, actual)
      @conform = no

  compareValues: (expected, actual) ->
    ###
    The core function of the `Comparator`.
    It successfully checks all the potential equality or matching cases, and will recursively create a new comparator
    for nested objects and arrays.
    ###
    if _.isEqual expected, actual
      return yes
    if (_.isPlainObject expected) or (_.isArray expected)
      # recursive call on the nested objects
      return @constructor.check actual, expected, @options
    if @options.regex and _.isRegExp expected
      return (_.isString actual) and (actual.match expected)
    if @options.types and expected?.prototype?.hasOwnProperty('constructor')
      return actual?.constructor is expected
    return no

  @check: (actual, expected, options) =>
    ###
    Checks the actual object against an expected specification.
    Returns `true` if it is respected, `false` if not
    ###
    comparator = new @(expected, actual, options)
    return comparator.conform


module.exports = Comparator

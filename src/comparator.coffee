
_ = require 'lodash'

class Comparator

  ###
  METHODS
  ###

  constructor: (@expected, @actual, options) ->
    @options = {}
    for optionName in ['partial', 'regex', 'types']
      @options[optionName] = not (options?[optionName] is no)
    @discrepency = []
    @displayActual = {}
    @conform = yes
    @comparePartial()
    if not @options.partial
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
    if _.isPlainObject expected
      subComparator = new @constructor expected, actual, @options
      return subComparator.conform
    if @options.regex and _.isRegExp expected
      return (_.isString actual) and (actual.match expected)
    if @options.types and expected?.prototype?.hasOwnProperty('constructor')
      return actual?.constructor is expected
    return no


module.exports = Comparator

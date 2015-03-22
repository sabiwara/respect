
_ = require 'lodash'

class Comparator

  constructor: (@expected, @actual) ->
    @discrepency = []
    @displayActual = {}
    for key, value of @expected
      @compareKey(key, value)

  compareKey: (key, expected) ->
    actual = @actual[key]
    @displayActual[key] = actual
    if !@compareValues(expected, actual)
      @discrepency.push(key)

  compareValues: (expected, actual) ->
    if expected?.prototype?.hasOwnProperty('constructor')
      return actual?.constructor == expected
    return _.isEqual expected, actual

  assert: (ctx) ->
    ctx.assert(
      !@discrepency.length,
      'expected #{this} to match #{exp} but got #{act}',
      'expected #{this} not to match #{exp}',
      @expected,
      @displayActual
    )

module.exports = Comparator

Comparator = require './comparator'

match = (expected) ->
  comparator = new Comparator(expected, this._obj)
  comparator.assert(this)

hikaku = (chai, utils) ->
  utils.addMethod chai.Assertion.prototype, 'match', match

hikaku.Comparator = Comparator


module.exports = hikaku
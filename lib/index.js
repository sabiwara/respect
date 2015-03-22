(function() {
  var Comparator, hikaku, match;

  Comparator = require('./comparator');

  match = function(expected) {
    var comparator;
    comparator = new Comparator(expected, this._obj);
    return comparator.assert(this);
  };

  hikaku = function(chai, utils) {
    return utils.addMethod(chai.Assertion.prototype, 'match', match);
  };

  hikaku.Comparator = Comparator;

  module.exports = hikaku;

}).call(this);

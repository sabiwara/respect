(function() {
  var Comparator, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('lodash');

  Comparator = (function() {

    /*
    METHODS
     */
    function Comparator(expected1, actual1, options) {
      var i, len, optionName, ref;
      this.expected = expected1;
      this.actual = actual1;
      if (options == null) {
        options = {};
      }
      this.compareKey = bind(this.compareKey, this);
      this.checkForMissingKeys = bind(this.checkForMissingKeys, this);
      this.comparePartial = bind(this.comparePartial, this);
      ref = ['partial', 'regex', 'types'];
      for (i = 0, len = ref.length; i < len; i++) {
        optionName = ref[i];
        this[optionName] = !(options[optionName] === false);
      }
      this.discrepency = [];
      this.displayActual = {};
      this.conform = true;
      this.comparePartial();
      if (!this.partial) {
        this.checkForMissingKeys();
      }
    }

    Comparator.prototype.comparePartial = function() {
      var key, ref, results, value;
      ref = this.expected;
      results = [];
      for (key in ref) {
        value = ref[key];
        results.push(this.compareKey(key, value));
      }
      return results;
    };

    Comparator.prototype.checkForMissingKeys = function() {
      var key, results;
      results = [];
      for (key in this.actual) {
        if (!(key in this.expected)) {
          results.push(this.compareKey(key, void 0));
        }
      }
      return results;
    };

    Comparator.prototype.compareKey = function(key, expected) {
      var actual;
      actual = this.actual[key];
      this.displayActual[key] = actual;
      if (!this.compareValues(expected, actual)) {
        this.discrepency.push(key);
        return this.conform = false;
      }
    };

    Comparator.prototype.compareValues = function(expected, actual) {
      var ref;
      if (_.isEqual(expected, actual)) {
        return true;
      }
      if (_.isRegExp(expected)) {
        return (_.isString(actual)) && (actual.match(expected));
      }
      if (expected != null ? (ref = expected.prototype) != null ? ref.hasOwnProperty('constructor') : void 0 : void 0) {
        return (actual != null ? actual.constructor : void 0) === expected;
      }
      return false;
    };

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

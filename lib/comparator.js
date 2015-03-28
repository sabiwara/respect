(function() {
  var Comparator, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('lodash');

  Comparator = (function() {

    /*
    METHODS
     */
    Comparator.DEFAULT_OPTIONS = {
      partial: true,
      regex: true,
      types: true
    };

    function Comparator(expected1, actual1, options) {
      var base, defaultValue, optionName, ref;
      this.expected = expected1;
      this.actual = actual1;
      this.compareKey = bind(this.compareKey, this);
      this.checkForMissingKeys = bind(this.checkForMissingKeys, this);
      this.comparePartial = bind(this.comparePartial, this);
      this.options = {};
      ref = this.constructor.DEFAULT_OPTIONS;
      for (optionName in ref) {
        defaultValue = ref[optionName];
        this.options[optionName] = options != null ? options[optionName] : void 0;
        if ((base = this.options)[optionName] == null) {
          base[optionName] = defaultValue;
        }
      }
      this.discrepency = [];
      this.displayActual = {};
      this.conform = true;
      this.comparePartial();
      if (!this.options.partial) {
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
      var ref, subComparator;
      if (_.isEqual(expected, actual)) {
        return true;
      }
      if (_.isPlainObject(expected)) {
        subComparator = new this.constructor(expected, actual, this.options);
        return subComparator.conform;
      }
      if (this.options.regex && _.isRegExp(expected)) {
        return (_.isString(actual)) && (actual.match(expected));
      }
      if (this.options.types && (expected != null ? (ref = expected.prototype) != null ? ref.hasOwnProperty('constructor') : void 0 : void 0)) {
        return (actual != null ? actual.constructor : void 0) === expected;
      }
      return false;
    };

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

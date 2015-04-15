(function() {
  var Comparator, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('lodash/lang');

  Comparator = (function() {

    /*
    The underlying class handling all comparisons. It is not aware of any assertion library and simply evaluates
    that an `actual` object **respects** an `expected` specification.
     */
    Comparator.DEFAULT_OPTIONS = {
      partial: true,
      regex: true,
      types: true,
      lambdas: true
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
      this.conform = true;
      this.comparePartial();
      if (!this.options.partial) {
        this.checkForMissingKeys();
      }
    }

    Comparator.prototype.comparePartial = function() {

      /*
      Compares only keys that are present in the expected specification
       */
      var key, ref, results, value;
      if ((this.expected != null) === !(this.actual != null)) {
        return this.conform = false;
      }
      if (_.isArray(this.expected)) {
        if (!((_.isArray(this.actual)) && (this.actual.length === this.expected.length))) {
          return this.conform = false;
        }
      }
      ref = this.expected;
      results = [];
      for (key in ref) {
        value = ref[key];
        if (this.conform) {
          results.push(this.compareKey(key, value));
        }
      }
      return results;
    };

    Comparator.prototype.checkForMissingKeys = function() {

      /*
      Checks keys from the expected specification that are not present in the actual object
       */
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

      /*
      Checks a key from the actual object regarding to the expected value for that key
       */
      var actual;
      actual = this.actual[key];
      if (!this.compareValues(expected, actual)) {
        return this.conform = false;
      }
    };

    Comparator.prototype.compareValues = function(expected, actual) {

      /*
      The core function of the `Comparator`.
      It successfully checks all the potential equality or matching cases, and will recursively create a new comparator
      for nested objects and arrays.
       */
      var isConstructor;
      if (_.isEqual(expected, actual)) {
        return true;
      }
      if ((_.isPlainObject(expected)) || (_.isArray(expected))) {
        return this.constructor.check(actual, expected, this.options);
      }
      if (this.options.regex && _.isRegExp(expected)) {
        return (_.isString(actual)) && (actual.match(expected));
      }
      isConstructor = this.constructor.isConstructor(expected);
      if (this.options.types && isConstructor) {
        return (actual != null ? actual.constructor : void 0) === expected;
      }
      if (this.options.lambdas && (!isConstructor) && _.isFunction(expected)) {
        return !!expected(actual);
      }
      return false;
    };

    Comparator.isConstructor = function(item) {

      /*
      Checks if the given item is a constructor or not
       */
      var proto;
      proto = item != null ? item.prototype : void 0;
      return !!((proto != null ? proto.hasOwnProperty('constructor') : void 0) && proto.constructor.name);
    };

    Comparator.check = function(actual, expected, options) {

      /*
      Checks the actual object against an expected specification.
      Returns `true` if it is respected, `false` if not
       */
      var comparator;
      comparator = new Comparator(expected, actual, options);
      return comparator.conform;
    };

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

(function() {
  var Comparator, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  _ = require('lodash');

  Comparator = (function() {
    Comparator.prototype.KEYWORD = 'respect';


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

    Comparator.prototype.chaiAssert = function(ctx) {
      var keyword;
      keyword = this.KEYWORD;
      return ctx.assert(this.conform, "expected " + '#{this}' + " to " + keyword + " " + '#{exp}' + " but got " + '#{act}', "expected " + '#{this}' + " not to " + keyword + " " + '#{exp}', this.expected, this.displayActual);
    };

    Comparator.prototype.shouldAssert = function(ctx) {
      ctx.params = {
        operator: "to " + this.KEYWORD,
        expected: this.expected
      };
      if (!this.conform) {
        return ctx.fail();
      }
    };


    /*
    STATICS
     */

    Comparator.spawnSubClass = function(alias) {
      var ComparatorClass;
      ComparatorClass = (function(superClass) {
        extend(ComparatorClass, superClass);

        function ComparatorClass() {
          return ComparatorClass.__super__.constructor.apply(this, arguments);
        }

        return ComparatorClass;

      })(this);
      if (alias) {
        ComparatorClass.prototype.KEYWORD = alias;
      }
      return ComparatorClass;
    };

    Comparator.addToChai = function(chaiModule, alias) {
      var ComparatorClass;
      ComparatorClass = this.spawnSubClass(alias);
      chaiModule.use(function(chai, utils) {
        return utils.addMethod(chai.Assertion.prototype, ComparatorClass.prototype.KEYWORD, function(expected, options) {
          var comparator;
          comparator = new ComparatorClass(expected, this._obj, options);
          return comparator.chaiAssert(this);
        });
      });
      return chaiModule;
    };

    Comparator.addToShould = function(shouldModule, alias) {
      var ComparatorClass;
      ComparatorClass = this.spawnSubClass(alias);
      shouldModule.use(function(should, Assertion) {
        return Assertion.add(ComparatorClass.prototype.KEYWORD, function(expected, options) {
          var comparator;
          comparator = new ComparatorClass(expected, this.obj, options);
          return comparator.shouldAssert(this);
        });
      });
      return shouldModule;
    };

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

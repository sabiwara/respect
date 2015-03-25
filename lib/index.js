(function() {
  var Comparator, _;

  _ = require('lodash');

  Comparator = (function() {

    /*
    METHODS
     */
    function Comparator(expected1, actual1) {
      var key, ref, value;
      this.expected = expected1;
      this.actual = actual1;
      this.discrepency = [];
      this.displayActual = {};
      this.conform = true;
      ref = this.expected;
      for (key in ref) {
        value = ref[key];
        this.compareKey(key, value);
      }
    }

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
      if (expected != null ? (ref = expected.prototype) != null ? ref.hasOwnProperty('constructor') : void 0 : void 0) {
        return (actual != null ? actual.constructor : void 0) === expected;
      }
      return _.isEqual(expected, actual);
    };

    Comparator.prototype.chaiAssert = function(ctx) {
      var keyword;
      keyword = this.constructor.KEYWORD;
      return ctx.assert(this.conform, "expected " + '#{this}' + " to " + keyword + " " + '#{exp}' + " but got " + '#{act}', "expected " + '#{this}' + " not to " + keyword + " " + '#{exp}', this.expected, this.displayActual);
    };

    Comparator.prototype.shouldAssert = function(ctx) {
      var keyword;
      keyword = this.constructor.KEYWORD;
      ctx.params = {
        operator: "to " + keyword,
        expected: this.expected
      };
      if (!this.conform) {
        return ctx.fail();
      }
    };


    /*
    STATICS
     */

    Comparator.KEYWORD = 'conform';

    Comparator.addToChai = function(chaiModule) {
      var ComparatorClass;
      ComparatorClass = this;
      chaiModule.use(function(chai, utils) {
        return utils.addMethod(chai.Assertion.prototype, ComparatorClass.KEYWORD, function(expected) {
          var comparator;
          comparator = new ComparatorClass(expected, this._obj);
          return comparator.chaiAssert(this);
        });
      });
      return chaiModule;
    };

    Comparator.addToShould = function(shouldModule) {
      var ComparatorClass;
      ComparatorClass = this;
      shouldModule.use(function(should, Assertion) {
        return Assertion.add(ComparatorClass.KEYWORD, function(expected) {
          var comparator;
          comparator = new ComparatorClass(expected, this.obj);
          return comparator.shouldAssert(this);
        });
      });
      return shouldModule;
    };

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

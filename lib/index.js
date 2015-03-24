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
        return this.discrepency.push(key);
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
      return ctx.assert(!this.discrepency.length, "expected " + '#{this}' + " to " + this.constructor.KEYWORD + " " + '#{exp}' + " but got " + '#{act}', "expected " + '#{this}' + " not to " + this.constructor.KEYWORD + " " + '#{exp}', this.expected, this.displayActual);
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

    return Comparator;

  })();

  module.exports = Comparator;

}).call(this);

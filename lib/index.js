(function() {
  var Comparator, _,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  _ = require('lodash');

  Comparator = (function() {
    Comparator.prototype.KEYWORD = 'respect';


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
      if (_.isRegExp(expected)) {
        return (_.isString(actual)) && (actual.match(expected));
      }
      if (expected != null ? (ref = expected.prototype) != null ? ref.hasOwnProperty('constructor') : void 0 : void 0) {
        return (actual != null ? actual.constructor : void 0) === expected;
      }
      return _.isEqual(expected, actual);
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
        console.log('chai.should.', ComparatorClass.prototype.KEYWORD);
        return utils.addMethod(chai.Assertion.prototype, ComparatorClass.prototype.KEYWORD, function(expected) {
          var comparator;
          comparator = new ComparatorClass(expected, this._obj);
          return comparator.chaiAssert(this);
        });
      });
      return chaiModule;
    };

    Comparator.addToShould = function(shouldModule, alias) {
      var ComparatorClass;
      ComparatorClass = this.spawnSubClass(alias);
      shouldModule.use(function(should, Assertion) {
        console.log('should.', ComparatorClass.prototype.KEYWORD);
        return Assertion.add(ComparatorClass.prototype.KEYWORD, function(expected) {
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

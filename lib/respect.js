
/*
 * respect.js
Comparison plugin for BDD assertion libraries ([chai](http://chaijs.com/),
[should](https://www.npmjs.com/package/should))
 */

(function() {
  var AssertionPlugin, Comparator, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Comparator = require('./comparator');

  AssertionPlugin = (function(superClass) {
    extend(AssertionPlugin, superClass);

    function AssertionPlugin() {
      return AssertionPlugin.__super__.constructor.apply(this, arguments);
    }


    /*
    The actual `respect` object that implements the interface with external BDD assertion libraries
    (**chai**, **should**).
    Can be extended at will to add custom behaviours.
     */


    /*
    INSTANCE
     */

    AssertionPlugin.prototype.KEYWORD = 'respect';

    AssertionPlugin.prototype.chaiAssert = function(ctx) {

      /*
      Defines the content of the assertion method for a comparator within the **chai** plugin for a context `ctx`
       */
      var keyword;
      keyword = this.KEYWORD;
      return ctx.assert(this.conform, "expected " + '#{this}' + " to " + keyword + " " + '#{exp}', "expected " + '#{this}' + " not to " + keyword + " " + '#{exp}' + " (false negative fail)", this.expected, this.actual, true);
    };

    AssertionPlugin.prototype.shouldAssert = function(ctx) {

      /*
      Defines the content of the assertion method for a comparator within the **should** plugin for a context `ctx`
       */
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

    AssertionPlugin.parseCustom = function(rawOptions) {

      /*
      Parses the `options` object from `spawnSubClass` into something that can be used to extend into a custom subclass
       */
      var alias, defaultValue, optionName, options, ref;
      alias = rawOptions != null ? rawOptions.alias : void 0;
      options = {};
      ref = this.DEFAULT_OPTIONS;
      for (optionName in ref) {
        defaultValue = ref[optionName];
        options[optionName] = rawOptions != null ? rawOptions[optionName] : void 0;
        if (options[optionName] == null) {
          options[optionName] = defaultValue;
        }
      }
      return [alias, options];
    };

    AssertionPlugin.spawnSubClass = function(options) {

      /*
      Dynamically extends the class to use the given options
       */
      var ComparatorClass, alias, ref;
      ComparatorClass = (function(superClass1) {
        extend(ComparatorClass, superClass1);

        function ComparatorClass() {
          return ComparatorClass.__super__.constructor.apply(this, arguments);
        }

        return ComparatorClass;

      })(AssertionPlugin);
      ref = AssertionPlugin.parseCustom(options), alias = ref[0], options = ref[1];
      if (alias) {
        ComparatorClass.prototype.KEYWORD = alias;
      }
      ComparatorClass.DEFAULT_OPTIONS = options;
      return ComparatorClass;
    };

    AssertionPlugin.chaiPlugin = function(options) {

      /*
      Generates a `AssertionPlugin` subclass and defines a plugin for **chai** that relies on it for assertions
       */
      return (function(_this) {
        return function(chai, utils) {
          var ComparatorClass;
          ComparatorClass = _this.spawnSubClass(options);
          return utils.addMethod(chai.Assertion.prototype, ComparatorClass.prototype.KEYWORD, function(expected, options) {
            var comparator;
            comparator = new ComparatorClass(expected, this._obj, options);
            return comparator.chaiAssert(this);
          });
        };
      })(this);
    };

    AssertionPlugin.shouldPlugin = function(options) {

      /*
      Generates a `AssertionPlugin` subclass and defines a plugin for **should** that relies on it for assertions
       */
      return (function(_this) {
        return function(should, Assertion) {
          var ComparatorClass;
          ComparatorClass = _this.spawnSubClass(options);
          return Assertion.add(ComparatorClass.prototype.KEYWORD, function(expected, options) {
            var comparator;
            comparator = new ComparatorClass(expected, this.obj, options);
            return comparator.shouldAssert(this);
          });
        };
      })(this);
    };

    return AssertionPlugin;

  })(Comparator);

  exports = module.exports = AssertionPlugin;

}).call(this);

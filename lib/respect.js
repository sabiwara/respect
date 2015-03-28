(function() {
  var Comparator, RespectPlugin,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Comparator = require('./comparator');

  RespectPlugin = (function(superClass) {
    extend(RespectPlugin, superClass);

    function RespectPlugin() {
      return RespectPlugin.__super__.constructor.apply(this, arguments);
    }

    RespectPlugin.prototype.KEYWORD = 'respect';

    RespectPlugin.prototype.chaiAssert = function(ctx) {
      var keyword;
      keyword = this.KEYWORD;
      return ctx.assert(this.conform, "expected " + '#{this}' + " to " + keyword + " " + '#{exp}' + " but got " + '#{act}', "expected " + '#{this}' + " not to " + keyword + " " + '#{exp}', this.expected, this.displayActual);
    };

    RespectPlugin.prototype.shouldAssert = function(ctx) {
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

    RespectPlugin.spawnSubClass = function(alias) {
      var ComparatorClass;
      ComparatorClass = (function(superClass1) {
        extend(ComparatorClass, superClass1);

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

    RespectPlugin.addToChai = function(chaiModule, alias) {
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

    RespectPlugin.addToShould = function(shouldModule, alias) {
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

    return RespectPlugin;

  })(Comparator);

  module.exports = RespectPlugin;

}).call(this);

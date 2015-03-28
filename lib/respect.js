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
      return ctx.assert(this.conform, "expected " + '#{this}' + " to " + keyword + " " + '#{exp}', "expected " + '#{this}' + " not to " + keyword + " " + '#{exp}' + " (false negative fail)", this.expected, this.displayActual);
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

    RespectPlugin.parseCustom = function(custom) {
      var alias, defaultValue, optionName, options, ref;
      alias = custom != null ? custom.alias : void 0;
      options = {};
      ref = this.DEFAULT_OPTIONS;
      for (optionName in ref) {
        defaultValue = ref[optionName];
        options[optionName] = custom != null ? custom[optionName] : void 0;
        if (options[optionName] == null) {
          options[optionName] = defaultValue;
        }
      }
      return [alias, options];
    };

    RespectPlugin.spawnSubClass = function(custom) {
      var ComparatorClass, alias, options, ref;
      ComparatorClass = (function(superClass1) {
        extend(ComparatorClass, superClass1);

        function ComparatorClass() {
          return ComparatorClass.__super__.constructor.apply(this, arguments);
        }

        return ComparatorClass;

      })(this);
      ref = this.parseCustom(custom), alias = ref[0], options = ref[1];
      if (alias) {
        ComparatorClass.prototype.KEYWORD = alias;
      }
      ComparatorClass.DEFAULT_OPTIONS = options;
      return ComparatorClass;
    };

    RespectPlugin.chaiPlugin = function(custom) {
      return (function(_this) {
        return function(chai, utils) {
          var ComparatorClass;
          ComparatorClass = _this.spawnSubClass(custom);
          return utils.addMethod(chai.Assertion.prototype, ComparatorClass.prototype.KEYWORD, function(expected, options) {
            var comparator;
            comparator = new ComparatorClass(expected, this._obj, options);
            return comparator.chaiAssert(this);
          });
        };
      })(this);
    };

    RespectPlugin.shouldPlugin = function(custom) {
      return (function(_this) {
        return function(should, Assertion) {
          var ComparatorClass;
          ComparatorClass = _this.spawnSubClass(custom);
          return Assertion.add(ComparatorClass.prototype.KEYWORD, function(expected, options) {
            var comparator;
            comparator = new ComparatorClass(expected, this.obj, options);
            return comparator.shouldAssert(this);
          });
        };
      })(this);
    };

    return RespectPlugin;

  })(Comparator);

  module.exports = RespectPlugin;

}).call(this);

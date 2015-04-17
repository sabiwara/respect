# respect.js

[![Build Status](https://travis-ci.org/sabiwara/respect.svg?branch=master)](https://travis-ci.org/sabiwara/respect)

Comparison plugin for BDD assertion libraries ([chai](http://chaijs.com/),
[should](https://www.npmjs.com/package/should))


## Installation

### In node.js:

``` bash
$ npm install respect --save-dev
```

### In  the browser

```html
<script src="respect.min.js" type="text/javascript"></script>
```

## tl;dr

The philosophy behind `respect.js` is to extend BDD assertions to make quick and comprehensive object comparisons.
It extends `should`-like assertions with a `respect` method that takes a specification and checks it matches.

```javascript
var record = {
  _id: '5515ce73959470012aef024a',
  name: 'Eva Warner',
  age: 23,
  lastLogin: new Date('2014-05-20 07:51:36'),
  particularity: 'Matches this Regex',
  nestedObj: {
    nestedArray: [5, '34', null, true]
  },
  anotherArray: [{
    willBeChecked: true
  }, {
    willBeChecked: false
  }],
  other: 'Not relevant, will be ignored in the test'
};
record.should.respect({
  name: 'Eva Warner',
  age: function(age) {
    return (age >= 7) && (age <= 77);
  },
  lastLogin: Date,
  particularity: /regex/i,
  nestedObj: {
    nestedArray: [5, String, null, Boolean]
  },
  anotherArray: {
    0: {
      willBeChecked: true
    },
    length: 2
  },
  unexpectedPropertyThatShouldNotBeHere: undefined
});
```

This flexible approach can make data-comparing unit-tests less heavy and more expressive,
especially when it comes to database documents for instance:
 - no need to omit/pick fields before a deep comparison because they are irrelevant or unpredictable (ids, dates...)
 - easy-to-write one-shot comparison that can check an equality, but also a regex match or a constructor...

In one words, it checks if an object **respects a specification** rather than comparing two objects.


## API


### Declaration

```javascript
var respect = require('respect');
```

#### With [should](https://www.npmjs.com/package/should)

```javascript
var should = require('should');
should.use(respect.shouldPlugin());
```

#### With [chai](http://chaijs.com/)

```javascript
var chai = require('chai');
chai.use(respect.chaiPlugin());

// Then, according to your preferences:
var should = chai.should();
// OR
var expect = chai.expect;
```


### Assertions

The generic syntax is:

```javascript
data.should.respect(specifications, options);
// OR
expect(data).to.respect(specifications, options);
```

Nested objects are compared recursively, and arrays are iterated over.
`options` can be omitted: by default all the following options are set to `true`:

#### `partial`: Ignore un-specified fields

```javascript
var record = {
  notImportant: 'It is here but we do not need to check for it'
};
record.should.respect({
  butThisFieldShouldBeAbsent: undefined
});
```

*Note:* if the record object does have the `butThisFieldShouldBeAbsent` field, an exception will be raised.

This behaviour can be deactivated by providing a `{ partial: false }` option.

#### `regex`: Regex shortcuts

```javascript
var record = {
  uuid: 'bbd4e20b-cdd4-5107-ad63-02a2cfc23c5b'
};
record.should.respect({
  uuid: /^[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$/i
});
```

This behaviour can be deactivated by providing a `{ regex: false }` option.

#### `types`: Constructors shortcut

```javascript
var record = {
  name: 'John',
  age: 55,
  now: new Date(),
  pattern: /[aA]bc.\s/,
  dateConstructor: Date,
  regexConstructor: RegExp
};
record.should.respect({
  name: String,
  age: function(age) {
    return (age >= 7) && (age <= 77);
  },
  now: Date,
  pattern: RegExp,
  dateConstructor: Date,
  regexConstructor: RegExp
});
```

This behaviour can be deactivated by providing a `{ types: false }` option.

#### `lambdas`: Lambda evaluation functions shortcut

```javascript
var record = {
  name: 'John',
  age: 55
};
record.should.respect({
  name: 'John',
  age: function(age) {
    return (age >= 7) && (age <= 77);
  }
});
```

This behaviour can be deactivated by providing a `{ lambdas: false }` option.


### Override default behaviours

#### On the assertion level:

Example of changing default behaviours:

```javascript
// will raise assertion multiple errors because of options
var record = {
  description: 'matches the regex but is a string',
  now: new Date(),
  fieldThatShouldNotBeHere: true   // will not be accepted because partial=false
};
record.should.respect({
  description: /regex/,            // will fail because regex=false
  now: Date                        // will fail because types=false
}, {
  partial: false,
  regex: false,
  types: false
});
```

In this extreme example, every option is removed so the comparison ends up to a *deep equal*.
Whereas it can be necessary to deactivate one given behaviour for specific cases, it is silly to use `respect`
in place of a deep equal comparator. Just use the already implemented `should.deep.equal`.


#### On the plugin level

`chaiPlugin` and `shouldPlugin` both accept an `options` object, which can override the default behaviours for
all assertions made from this module.
Besides, for those who prefer to use their own keyword instead of the default `'respect'`,
you can easily pick your own alias by providing an `alias` option when generating the plugin.
You can even declare several plugins with different options under different aliases.

```javascript
var chai = require('chai');
var respect = require('respect');
chai.use(respect.chaiPlugin({ alias: 'matchStrictly', partial: false, types: false }));
chai.use(respect.chaiPlugin({ alias: 'matchAll', partial: false }));
chai.use(respect.chaiPlugin({ alias: 'matchPartially' }));
chai.should();

var record = {
  name: 'Jimmy Hudson',
  age: 54,
  male: true
};

// Will fail because of the unactivated `types` option
record.should.matchStrictly({ name: String, age: Number, male: Boolean });

// Will fail because of the unactivated `partial` option and the missing 'male' key
record.should.matchAll({ name: String, age: Number });

// Will succeed
record.should.matchPartially({ name: String, age: Number });
```

#### Extend the comparison methods


```javascript
var Comparator = require('respect');
var MyComparator = // TODO write extension code (examples to come)
chai.use(MyComparator.chaiPlugin());
```

### Comparisons outside of BDD assertions

If you want to use `respect` as a comparison util outside of BDD assertions, you can simply use its `check()` method.

```javascript
// respect.check(actual, expected, [options])
var record = {
  name: 'Darth Vader',
  badass: true
};
respect.check(record, { badass: true });                      // true
respect.check(record, { badass: true }, { partial: false });  // false
```

## Tests

```bash
$ npm test
```

## Documentation

```bash
$ npm run gen-doc
```

## License

MIT License Copyright (c) 2015 Sabiwara

# respect.js

Comparison plugin for BDD assertion libraries (chai, should)


## Installation

``` bash
  $ npm install respect --save-dev
```


## tl;dr

The idea behind `respect.js` is to extend BDD assertions to make quick and comprehensive object comparisons.
It extends `should`-like assertions with a `respect` method that takes a specification and checks it matches.

```javascript
var record = {
  _id: '5515ce73959470012aef024a',
  name: 'Eva Warner',
  age: 23,
  lastLogin: new Date('2014-20-05 07:51:36'),
  particularity: 'Matches this Regex',
  other: 'Not relevant, will be ignored in the test'
};
record.should.respect({
  name: 'Eva Warner',
  age: 23
  lastLogin: Date,
  particularity: /regex/i,
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

#### With `should.js`

```javascript
  var should = require('should');
  should.use(require('respect').shouldPlugin());
```

#### With `chai.js`

```javascript
  var chai = require('chai');
  chai.use(require('respect').chaiPlugin());

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

`options` is optional and can be ommitted. By default all the following options are set to `true`:

#### `partial`: Ignore un-specified fields

```javascript
  {
    notImportant: 'It is here but we do not need to check for it'
  }.should.respect({
    butThisFieldShouldBeAbsent: undefined
  });
```

*Note:* if the record object does have the `butThisFieldShouldBeAbsent` field, an exception will be raised.

This behaviour can be deactivated by providing a `{ partial: false }` option.

#### `regex`: Regex shortcuts

```javascript
  {
    uuid: 'bbd4e20b-cdd4-5107-ad63-02a2cfc23c5b'
  }.should.respect({
    uuid: /^[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$/
  });
```

This behaviour can be deactivated by providing a `{ regex: false }` option.

#### `types`: Constructors shortcut

```javascript
  {
    name: 'John',
    age: 55,
    now: new Date(),
    pattern: /[aA]bc.\s/,
    dateConstructor: Date,
    regexConstructor: RegExp
  }.should.respect({
    name: String,
    age: Number,
    now: Date,
    pattern: RegExp,
    dateConstructor: Date,
    regexConstructor: RegExp
  });
```

This behaviour can be deactivated by providing a `{ types: false }` option.


#### Change default behaviours

Example of changing default behaviours:

```javascript
  // will raise assertion multiple errors because of options
  {
    description: 'matches the regex but is a string',
    now: new Date(),
    fieldThatShouldNotBeHere: true  // will not be accepted because partial=false
  }.should.respect({
    description: /regex/,  // will fail because regex=false
    now: Date // will fail because types=false
  }, {
      partial: false,
      regex: false,
      types: false
  });
```

In this extreme example, every option is removed so the comparison ends up to a *deep equal*.
Whereas it can be necessary to deactivate one given behaviour for specific cases, it is silly to use `respect`
in place of a deep equal comparator. Just use the already implemented `should.deep.equal`.


### Other features

#### Change the `'respect'` keyword

For those who prefer to use their own keyword instead of the default `'respect'`, you can easily pick your own alias.

```javascript
  var chai = require('chai');
  chai.use(require('respect').chaiPlugin('matchSpec'));
  chai.should();

  { name: 'Jimmy Hudson', age: 54, male: true }.should.matchSpec({ name: String, age: Number });
```

#### Extend the comparison methods


```javascript
  var Comparator = require('respect'); 
  var MyComparator = // TODO write extension code (examples to come)
  chai.use(MyComparator.chaiPlugin());
```
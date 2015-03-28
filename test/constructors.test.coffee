
should = null
respect = require '..'


describe 'Constructor comparison', ->

  before ->
    delete Object::should
    chai = require 'chai'
    chai.use respect.chaiPlugin()
    should = chai.should()


  describe 'for String constructor', ->

    it 'should validate the String constructor (equality case)', ->
      { type: String }.should.respect { type: String }

    it 'should validate strings', ->
      { name: 'Akahige' }.should.respect { name: String }

    itShouldNot 'validate non-Date values', ->
      { name: /Akahige/ }.should.respect { name: String }
    , 'expected { name: /Akahige/ } to respect { name: [Function: String] }'


  describe 'for Number constructor', ->

    it 'should validate the Number constructor (equality case)', ->
      { type: Number }.should.respect { type: Number }

    it 'should validate Numbers', ->
      { age: 55 }.should.respect { age: Number }

    itShouldNot 'validate non-Date values', ->
      { age: '55' }.should.respect { age: Number }
    , 'expected { age: \'55\' } to respect { age: [Function: Number] }'


  describe 'for Boolean constructor', ->

    it 'should validate the Boolean constructor (equality case)', ->
      { type: Boolean }.should.respect { type: Boolean }

    it 'should validate Booleans', ->
      { male: true }.should.respect { male: Boolean }

    itShouldNot 'validate non-Date values', ->
      { male: null }.should.respect { male: Boolean }
    , 'expected { male: null } to respect { male: [Function: Boolean] }'


  describe 'for Date constructor', ->

    it 'should validate the Date constructor (equality case)', ->
      { type: Date }.should.respect { type: Date }

    it 'should validate Date objects', ->
      { now: new Date }.should.respect { now: Date }
      { now: new Date '2015-01-01' }.should.respect { now: Date }

    itShouldNot 'validate non-Date values', ->
      { a: 5 }.should.respect { a: Date }
    , 'expected { a: 5 } to respect { a: [Function: Date] }'

    itShouldNot 'not validate null values', ->
      { a: null }.should.respect { a: Date }
    , 'expected { a: null } to respect { a: [Function: Date] }'

    itShouldNot 'validate missing values', ->
      { }.should.respect { a: Date }
    , 'expected {} to respect { a: [Function: Date] }'


  describe 'for Date object', ->

    it 'should validate equal Date objects', ->
      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-01') }

    itShouldNot 'validate unequal Date objects', ->
      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-02') }
    , 'expected { Object (purchasedOn) } to respect { Object (purchasedOn) }'


  describe 'for RegExp constructor', ->

    it 'should validate the RegExp constructor (equality case)', ->
      { type: RegExp }.should.respect { type: RegExp }

    it 'should validate RegExp instances', ->
      { match: /^WtF[!?]]/ }.should.respect { match: RegExp }
      { match: new RegExp('^WtF[!?]]') }.should.respect { match: RegExp }

    itShouldNot 'validate non-RegExp values', ->
      { pattern: 'NotARegExp' }.should.respect { pattern: RegExp }
    , 'expected { pattern: \'NotARegExp\' } to respect { Object (pattern) }'


  describe 'when `types` option is disabled', ->

    itShouldNot 'validate partial matches when `types` is false', ->
      { now: new Date '2015-01-01' }.should.respect { now: Date }, types: false
    , 'expected { now: Thu, 01 Jan 2015 00:00:00 GMT } to respect { now: [Function: Date] }'
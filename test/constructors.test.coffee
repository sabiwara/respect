
should = null
respect = require '..'


describe 'Constructor comparison', ->

  before ->
    delete Object::should
    chai = require 'chai'
    chai.use respect.chaiPlugin()
    should = chai.should()

  describe 'Date constructor', ->

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


  describe 'Date object', ->

    it 'should validate equal Date objects', ->

      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-01') }

    itShouldNot 'validate unequal Date objects', ->
      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-02') }
    , 'expected { Object (purchasedOn) } to respect { Object (purchasedOn) }'


  describe 'RegExp constructor', ->

    it 'should validate the RegExp constructor (equality case)', ->

      { type: RegExp }.should.respect { type: RegExp }

    it 'should validate RegExp instances', ->

      { match: /^WtF[!?]]/ }.should.respect { match: RegExp }
      { match: new RegExp('^WtF[!?]]') }.should.respect { match: RegExp }

    itShouldNot 'validate non-RegExp values', ->
      { pattern: 'NotARegExp' }.should.respect { pattern: RegExp }
    , 'expected { pattern: \'NotARegExp\' } to respect { Object (pattern) }'

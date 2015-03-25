
should = null
hikaku = require '..'


before ->
  delete Object.prototype.should
  chai = require 'chai'
  hikaku.addToChai chai
  should = chai.should()

describe 'Constructor comparison', ->

  describe 'Date constructor', ->

    it 'should validate Date objects', ->

      { now: new Date }.should.respect { now: Date }
      { now: new Date '2015-01-01' }.should.respect { now: Date }

    itShouldNot 'validate non-Date values', ->
      { a: 5 }.should.respect { a: Date }
    , 'expected { a: 5 } to respect { a: [Function: Date] } but got { a: 5 }'

    itShouldNot 'not validate null values', ->
      { a: null }.should.respect { a: Date }
    , 'expected { a: null } to respect { a: [Function: Date] } but got { a: null }'

    itShouldNot 'validate missing values', ->
      { }.should.respect { a: Date }
    , 'expected {} to respect { a: [Function: Date] } but got { a: undefined }'


  describe 'Date object', ->

    it 'should validate equal Date objects', ->

      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-01') }

    itShouldNot 'validate unequal Date objects', ->
      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-02') }
    , 'expected { Object (purchasedOn) } to respect { Object (purchasedOn) } but got { Object (purchasedOn) }'
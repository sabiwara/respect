
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

    it 'should not validate non-Date values', ->
      err
      try
        { a: 5 }.should.respect { a: Date }
      catch e
        err = e
      finally
        assert err?.message, 'expected an error'
        err.message.should.equal('expected { a: 5 } to respect { a: [Function: Date] } but got { a: 5 }')

    it 'should not validate null values', ->
      err
      try
        { a: null }.should.respect { a: Date }
      catch e
        err = e
      finally
        assert err?.message, 'expected an error'
        err.message.should.equal('expected { a: null } to respect { a: [Function: Date] } but got { a: null }')

    it 'should not validate missing values', ->
      err
      try
        { }.should.respect { a: Date }
      catch e
        err = e
      finally
        assert err?.message, 'expected an error'
        err.message.should.equal 'expected {} to respect { a: [Function: Date] } but got { a: undefined }'

  describe 'Date object', ->

    it 'should validate equal Date objects', ->

      { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-01') }

    it 'should not validate unequal Date objects', ->

      err
      try
        { purchasedOn: (new Date '2015-01-01') }.should.respect { purchasedOn: (new Date '2015-01-02') }
      catch e
        err = e
      finally
        assert err?.message, 'expected an error'
        err.message.should.equal(
          'expected { Object (purchasedOn) } to respect { Object (purchasedOn) } but got { Object (purchasedOn) }'
        )
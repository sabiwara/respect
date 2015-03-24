
delete Object.prototype.should

chai = require 'chai'
hikaku = require '..'
hikaku.addToChai chai
should = chai.should()


describe 'Constructor comparison', ->

  describe 'Date constructor', ->

    it 'should validate Date objects', ->

      { now: new Date }.should.conform { now: Date }
      { now: new Date '2015-01-01' }.should.conform { now: Date }

    it 'should not validate non-Date values', ->
      err
      try
        { a: 5 }.should.conform { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal('expected { a: 5 } to conform { a: [Function: Date] } but got { a: 5 }')

    it 'should not validate null values', ->
      err
      try
        { a: null }.should.conform { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal('expected { a: null } to conform { a: [Function: Date] } but got { a: null }')

    it 'should not validate missing values', ->
      err
      try
        { }.should.conform { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal 'expected {} to conform { a: [Function: Date] } but got { a: undefined }'

  describe 'Date object', ->

    it 'should validate equal Date objects', ->

      { purchasedOn: (new Date '2015-01-01') }.should.conform { purchasedOn: (new Date '2015-01-01') }

    it 'should not validate unequal Date objects', ->

      err
      try
        { purchasedOn: (new Date '2015-01-01') }.should.conform { purchasedOn: (new Date '2015-01-02') }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal(
          'expected { Object (purchasedOn) } to conform { Object (purchasedOn) } but got { Object (purchasedOn) }'
        )
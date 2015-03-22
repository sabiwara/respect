
chai = require 'chai'
hikaku = require '../lib'
chai.use hikaku
should = chai.should()


describe 'Constructor comparison', ->

  describe 'Date constructor', ->

    it 'should validate Date objects', ->

      { now: new Date }.should.match { now: Date }
      { now: new Date '2015-01-01' }.should.match { now: Date }

    it 'should not validate non-Date values', ->
      err
      try
        { a: 5 }.should.match { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal('expected { a: 5 } to match { a: [Function: Date] } but got { a: 5 }')

    it 'should not validate null values', ->
      err
      try
        { a: null }.should.match { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal('expected { a: null } to match { a: [Function: Date] } but got { a: null }')

    it 'should not validate missing values', ->
      err
      try
        { }.should.match { a: Date }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal 'expected {} to match { a: [Function: Date] } but got { a: undefined }'

  describe 'Date object', ->

    it 'should validate equal Date objects', ->

      { purchasedOn: (new Date '2015-01-01') }.should.match { purchasedOn: (new Date '2015-01-01') }

    it 'should not validate unequal Date objects', ->

      err
      try
        { purchasedOn: (new Date '2015-01-01') }.should.match { purchasedOn: (new Date '2015-01-02') }
      catch e
        err = e
      finally
        should.exist err?.message, 'expected an error'
        err.message.should.equal(
          'expected { Object (purchasedOn) } to match { Object (purchasedOn) } but got { Object (purchasedOn) }'
        )
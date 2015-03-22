
chai = require 'chai'
hikaku = require '../lib'
chai.use hikaku
should = chai.should()


describe '#should.match', ->

  it 'should accept an exact match', ->
    {
      a: 5, b: 6
    }.should.match { a: 5, b: 6 }

  it 'should accept a partial match', ->
    {
    a: 5, b: 6
    }.should.match { a: 5 }

  it 'should not accept a missing key', ->
    err
    try
      {
      a: 5, b: 6
      }.should.match { a: 5, c: 7 }
    catch e
      err = e
    finally
      should.exist (err and err.message), 'Expected an error'
      err.message.should.equal 'expected { a: 5, b: 6 } to match { a: 5, c: 7 } but got { a: 5, c: undefined }'

should = null
hikaku = require '..'


before ->
  delete Object.prototype.should
  chai = require 'chai'
  hikaku.addToChai chai
  should = chai.should()

describe '#chai.should.respect', ->

  describe 'basic usage', ->

    it 'should accept an exact match', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5, b: 6 }

    it 'should accept a partial match', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5 }

    it 'should not accept a missing key', ->
      err
      try
        {
          a: 5, b: 6
        }.should.respect { a: 5, c: 7 }
      catch e
        err = e
      finally
        assert err?.message, 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } to respect { a: 5, c: 7 } but got { a: 5, c: undefined }'

  describe 'basic usage (negative form)', ->

    it 'should accept an exact match', ->
      try
        {
          a: 5, b: 6
        }.should.not.respect { a: 5, b: 6 }
      catch  e
        err = e
      finally
        assert err?.message, 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } not to respect { a: 5, b: 6 }'

    it 'should accept a partial match', ->
      try
        {
          a: 5, b: 6
        }.should.not.respect { a: 5 }
      catch  e
        err = e
      finally
        assert err?.message, 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } not to respect { a: 5 }'

    it 'should not accept a missing key', ->
      {
        a: 5, b: 6
      }.should.not.respect { a: 5, c: 7 }



  describe 'undefined/null keys', ->

    it 'should not match present undefined keys', ->
      err
      try
        {
          a: 5, b: 6
        }.should.respect { a: 5, b: undefined }
      catch e
        err = e
      finally
        assert err?.message, 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } to respect { a: 5, b: undefined } but got { a: 5, b: 6 }'

    it 'should match absent undefined keys', ->
      {
        a: 5, c: undefined
      }.should.respect { a: 5, b: undefined, c: undefined }

    it 'should not match present undefined keys', ->
      err
      try
        {
          a: 5, b: null
        }.should.respect { a: 5, b: undefined }
      catch e
        err = e
      finally
        assert err?.message, 'Expected an error'
        err.message.should.equal(
          'expected { a: 5, b: null } to respect { a: 5, b: undefined } but got { a: 5, b: null }'
        )

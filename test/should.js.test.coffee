
should
hikaku = require '..'

negativeFail =  '(false negative fail)'

describe '#should.conform', ->

  before ->
    delete Object.prototype.should
    should = require 'should'
    hikaku.addToShould should

  describe 'basic usage', ->

    it 'should accept an exact conform', ->
      {
        a: 5, b: 6
      }.should.conform { a: 5, b: 6 }

    it 'should accept a partial conform', ->
      {
        a: 5, b: 6
      }.should.conform { a: 5 }

    it 'should not accept a missing key', ->
      err
      try
        {
          a: 5, b: 6
        }.should.conform { a: 5, c: 7 }
      catch e
        err = e
      finally
        assert (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } to conform { a: 5, c: 7 }'

  describe 'basic usage (negative form)', ->

    it 'should accept an exact conform', ->
      try
        {
          a: 5, b: 6
        }.should.not.conform { a: 5, b: 6 }
      catch  e
        err = e
      finally
        assert (err and err.message), 'Expected an error'
        err.message.should.equal "expected { a: 5, b: 6 } not to conform { a: 5, b: 6 } #{ negativeFail }"

    it 'should accept a partial conform', ->
      try
        {
          a: 5, b: 6
        }.should.not.conform { a: 5 }
      catch  e
        err = e
      finally
        assert (err and err.message), 'Expected an error'
        err.message.should.equal "expected { a: 5, b: 6 } not to conform { a: 5 } #{ negativeFail }"

    it 'should not accept a missing key', ->
      {
        a: 5, b: 6
      }.should.not.conform { a: 5, c: 7 }



  describe 'undefined/null keys', ->

    it 'should not conform present undefined keys', ->
      err
      try
        {
          a: 5, b: 6
        }.should.conform { a: 5, b: undefined }
      catch e
        err = e
      finally
        assert (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } to conform { a: 5, b: undefined }'

    it 'should conform absent undefined keys', ->
      {
        a: 5, c: undefined
      }.should.conform { a: 5, b: undefined, c: undefined }

    it 'should not conform present undefined keys', ->
      err
      try
        {
          a: 5, b: null
        }.should.conform { a: 5, b: undefined }
      catch e
        err = e
      finally
        assert (err and err.message), 'Expected an error'
        err.message.should.equal(
          'expected { a: 5, b: null } to conform { a: 5, b: undefined }'
        )

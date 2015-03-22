
chai = require 'chai'
hikaku = require '../lib'
chai.use hikaku
should = chai.should()


describe '#should.match', ->

  describe 'basic usage', ->

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

  describe 'basic usage (negative form)', ->

    it 'should accept an exact match', ->
      try
        {
          a: 5, b: 6
        }.should.not.match { a: 5, b: 6 }
      catch  e
        err = e
      finally
        should.exist (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } not to match { a: 5, b: 6 }'

    it 'should accept a partial match', ->
      try
        {
          a: 5, b: 6
        }.should.not.match { a: 5 }
      catch  e
        err = e
      finally
        should.exist (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } not to match { a: 5 }'

    it 'should not accept a missing key', ->
      {
        a: 5, b: 6
      }.should.not.match { a: 5, c: 7 }



  describe 'undefined/null keys', ->

    it 'should not match present undefined keys', ->
      err
      try
        {
          a: 5, b: 6
        }.should.match { a: 5, b: undefined }
      catch e
        err = e
      finally
        should.exist (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: 6 } to match { a: 5, b: undefined } but got { a: 5, b: 6 }'

    it 'should match absent undefined keys', ->
      {
        a: 5, c: undefined
      }.should.match { a: 5, b: undefined, c: undefined }

    it 'should not match present undefined keys', ->
      err
      try
        {
          a: 5, b: null
        }.should.match { a: 5, b: undefined }
      catch e
        err = e
      finally
        should.exist (err and err.message), 'Expected an error'
        err.message.should.equal 'expected { a: 5, b: null } to match { a: 5, b: undefined } but got { a: 5, b: null }'


should = null
expect = null
respect = require '..'

negativeFail =  '(false negative fail)'

describe '#chaiPlugin', ->

  before ->
    delete Object::should
    chai = require 'chai'
    chai.use respect.chaiPlugin()
    should = chai.should()
    expect = chai.expect

  describe 'with should', ->

    describe 'basic usage', ->

      it 'should accept an exact match', ->
        { a: 5, b: 6 }.should.respect { a: 5, b: 6 }

      it 'should accept a partial match', ->
        { a: 5, b: 6 }.should.respect { a: 5 }

      itShouldNot 'accept a missing key', ->
        { a: 5, b: 6 }.should.respect { a: 5, c: 7 }
      , 'expected { a: 5, b: 6 } to respect { a: 5, c: 7 }'

    describe 'basic chain usage', ->

      it 'should be chainable', ->
        { a: 5, b: 6 }.should.respect(a: 5).and.have.property 'b'

      itShouldNot 'validate an object that violates the given chain', ->
        { a: 5, b: 6 }.should.respect(a: 5).and.have.property 'c'
      , 'expected { a: 5, b: 6 } to have a property \'c\''

    describe 'basic usage (negative form)', ->

      itShouldNot 'accept an exact match', ->
        { a: 5, b: 6 }.should.not.respect { a: 5, b: 6 }
      , "expected { a: 5, b: 6 } not to respect { a: 5, b: 6 } #{ negativeFail }"

      itShouldNot 'accept a partial match', ->
        { a: 5, b: 6 }.should.not.respect { a: 5 }
      , "expected { a: 5, b: 6 } not to respect { a: 5 } #{ negativeFail }"

      it 'should not accept a missing key', ->
        { a: 5, b: 6 }.should.not.respect { a: 5, c: 7 }


    describe 'undefined/null keys', ->

      itShouldNot 'match present undefined keys', ->
        { a: 5, b: 6 }.should.respect { a: 5, b: undefined }
      , 'expected { a: 5, b: 6 } to respect { a: 5, b: undefined }'

      it 'should match absent undefined keys', ->
        { a: 5, c: undefined }.should.respect { a: 5, b: undefined, c: undefined }

      itShouldNot 'match present undefined keys', ->
        { a: 5, b: null }.should.respect { a: 5, b: undefined }
      , 'expected { a: 5, b: null } to respect { a: 5, b: undefined }'


  describe 'with expect', ->

    it 'should accept an exact match', ->
      expect({ a: 5, b: 6 }).to.respect { a: 5, b: 6 }

    it 'should accept a partial match', ->
      expect({ a: 5, b: 6}).to.respect { a: 5 }

    itShouldNot 'accept a missing key', ->
      expect({ a: 5, b: 6 }).to.respect { a: 5, c: 7 }
    , 'expected { a: 5, b: 6 } to respect { a: 5, c: 7 }'

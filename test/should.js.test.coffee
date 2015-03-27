
should = null
respect = require '..'

negativeFail =  '(false negative fail)'

describe '#should.respect', ->

  before ->
    delete Object::should
    should = require 'should'
    respect.addToShould should
    # IMPORTANT: we have to do it ourselves since the requirement will not do it again
    should.extend('should', Object.prototype)

  describe 'basic usage', ->

    it 'should accept an exact match', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5, b: 6 }

    it 'should accept a partial match', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5 }

    itShouldNot 'accept a missing key', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5, c: 7 }
    , 'expected { a: 5, b: 6 } to respect { a: 5, c: 7 }'


  describe 'basic usage (negative form)', ->

    itShouldNot 'accept an exact match', ->
      {
        a: 5, b: 6
      }.should.not.respect { a: 5, b: 6 }
    , "expected { a: 5, b: 6 } not to respect { a: 5, b: 6 } #{ negativeFail }"

    itShouldNot 'accept a partial match', ->
      {
        a: 5, b: 6
      }.should.not.respect { a: 5 }
    , "expected { a: 5, b: 6 } not to respect { a: 5 } #{ negativeFail }"

    it 'should not accept a missing key', ->
      {
        a: 5, b: 6
      }.should.not.respect { a: 5, c: 7 }


  describe 'undefined/null keys', ->

    itShouldNot 'match present undefined keys', ->
      {
        a: 5, b: 6
      }.should.respect { a: 5, b: undefined }
    , 'expected { a: 5, b: 6 } to respect { a: 5, b: undefined }'

    it 'should match absent undefined keys', ->
      {
        a: 5, c: undefined
      }.should.respect { a: 5, b: undefined, c: undefined }

    itShouldNot 'match present undefined keys', ->
      {
        a: 5, b: null
      }.should.respect { a: 5, b: undefined }
    , 'expected { a: 5, b: null } to respect { a: 5, b: undefined }'

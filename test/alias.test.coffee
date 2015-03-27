
should = null
respect = require '..'


describe '#Aliases', ->


  describe ' with chai.should', ->

    before ->
      delete Object::should
      chai = require 'chai'
      respect.addToChai chai, 'match'
      should = chai.should()


    describe 'basic usage', ->

      itShouldNot 'accept a missing key', ->
        {
        a: 5, b: 6
        }.should.match { a: 5, c: 7 }
      , 'expected { a: 5, b: 6 } to match { a: 5, c: 7 } but got { a: 5, c: undefined }'

    describe 'basic usage (negative form)', ->

      itShouldNot 'accept an exact match', ->
        {
        a: 5, b: 6
        }.should.not.match { a: 5, b: 6 }
      , 'expected { a: 5, b: 6 } not to match { a: 5, b: 6 }'

  describe ' with should.js', ->

    before ->
      delete Object::should
      should = require 'should'
      respect.addToShould should, 'match'
      # IMPORTANT: we have to do it ourselves since the requirement will not do it again
      should.extend('should', Object.prototype)

    describe 'basic usage', ->

      itShouldNot 'accept a missing key', ->
        {
        a: 5, b: 6
        }.should.match { a: 5, c: 7 }
      , 'expected { a: 5, b: 6 } to match { a: 5, c: 7 }'

    describe 'basic usage (negative form)', ->

      itShouldNot 'accept an exact match', ->
        {
        a: 5, b: 6
        }.should.not.match { a: 5, b: 6 }
      , 'expected { a: 5, b: 6 } not to match { a: 5, b: 6 } (false negative fail)'



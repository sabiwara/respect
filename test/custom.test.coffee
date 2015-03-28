
should = null
respect = require '..'


describe 'Custom Comparator definition', ->

  describe ' with chai.should', ->

    before ->
      delete Object::should
      chai = require 'chai'
      chai.use respect.chaiPlugin(alias: 'matchAll', partial: false)
      should = chai.should()


    describe 'basic usage', ->

      itShouldNot 'accept a missing key', ->
        { a: 5, b: 6 }.should.matchAll { a: 5 }
      , 'expected { a: 5, b: 6 } to matchAll { a: 5 }'

    describe 'basic usage (negative form)', ->

      itShouldNot 'accept an exact matchAll', ->
        { a: 5, b: 6 }.should.not.matchAll { a: 5, b: 6 }
      , 'expected { a: 5, b: 6 } not to matchAll { a: 5, b: 6 } (false negative fail)'

  describe ' with should.js', ->

    before ->
      delete Object::should
      should = require 'should'
      should.use respect.shouldPlugin(alias: 'matchAll', partial: false)
      # IMPORTANT: we have to do it ourselves since the requirement will not do it again
      should.extend('should', Object.prototype)

    describe 'basic usage', ->

      itShouldNot 'accept a missing key', ->
        { a: 5, b: 6 }.should.matchAll { a: 5 }
      , 'expected { a: 5, b: 6 } to matchAll { a: 5 }'

    describe 'basic usage (negative form)', ->

      itShouldNot 'accept an exact matchAll', ->
        { a: 5, b: 6  }.should.not.matchAll { a: 5, b: 6 }
      , 'expected { a: 5, b: 6 } not to matchAll { a: 5, b: 6 } (false negative fail)'



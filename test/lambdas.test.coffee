
should = null
respect = require '..'


describe 'Function comparison', ->

  before ->
    delete Object::should
    chai = require 'chai'
    chai.use respect.chaiPlugin()
    should = chai.should()

  inRange = (age) ->
    7 <= age <= 77

  describe 'simple lambda function', ->

    it 'should validate a value within the range', ->
      { age: 7 }.should.respect age: inRange

    itShouldNot 'validate a value outside the range', ->
      { age: 6 }.should.respect age: inRange
    , 'expected { age: 6 } to respect { age: [Function] }'

  describe 'built-in methods', ->

    it 'should validate finite numbers with Number.isFinite', ->
      { age: 7 }.should.respect age: Number.isFinite

    itShouldNot 'validate infinite numbers with Number.isFinite', ->
      { age: Infinity }.should.respect age: Number.isFinite
    , 'expected { age: Infinity } to respect { age: [Function: isFinite] }'


  describe 'when `lambdas` option is disabled', ->

    itShouldNot 'validate a value within the range', ->
      { age: 7 }.should.respect
        age: inRange
      , lambdas: no
    , 'expected { age: 7 } to respect { age: [Function] }'

respect = null
assert = null

before ->
  respect = require '..'
  assert = require 'assert'

describe 'Comparator.check', ->

  it 'should validate a partially matching object', ->
    assert respect.check { a: 5, b: 6 }, { a: Number }

  it 'should not validate a partially matching object when partial=false', ->
    assert not respect.check { a: 5, b: 6 }, { a: Number }, { partial: false }

  it 'should not validate a constructor matching object when types=false', ->
    assert not respect.check { a: 5, b: 6 }, { a: Number }, { types: false }

  it 'should validate a matching array', ->
    assert respect.check [{ a: 5, b: 6 }], [{ a: Number }]

  it 'should not validate a non matching array', ->
    assert not respect.check [{ a: 5, b: 6 }], [{ a: Number }], { types: false }

  it 'should not validate an array of non matching length', ->
    assert not respect.check [{ a: 5, b: 6 }, undefined], [{ a: Number }]

  it 'should not validate null as an object', ->
    assert not respect.check null, {}

  it 'should not validate an object against a null specification', ->
    assert not respect.check {}, null

  it 'should not validate in case of a missing nested object', ->
    assert not respect.check {}, { nested: { mandatory: yes } }

  it 'should not validate when null replaces a missing nested object', ->
    assert not respect.check { nested: {} }, { nested: { mandatory: yes } }

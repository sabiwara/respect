
should = null
respect = require '..'


redefineChai = ->
  delete Object::should
  chai = require 'chai'
  chai.use respect.chaiPlugin()
  should = chai.should()


describe 'Nested objects comparison', ->

  before ->
    redefineChai()

  it 'should validate partially equal objects', ->

    doc =
      _id: '55167a304e067c005e573dc0'
      item: 'IDPXIDH-7890'
      qty: 5
      dates:
        purchase: new Date '2015-01-05'
        payment: new Date '2015-01-06'

    specification =
      item: 'IDPXIDH-7890'
      qty: 5
      dates:
        purchase: Date

    doc.should.respect specification

  it 'should unvalidate unmatching sub-objects', ->

    doc =
      _id: '55167a304e067c005e573dc0'
      item: 'IDPXIDH-7890'
      qty: 5
      dates:
        purchase: '2015-01-05'
        payment: '2015-01-06'

    specification =
      item: 'IDPXIDH-7890'
      qty: 5
      dates:
        purchase: Date

    doc.should.not.respect specification

  it 'should not validate partially equal objects if partial option is false', ->

    doc =
      item: 'IDPXIDH-7890'
      dates:
        purchase: new Date '2015-01-05'
        payment: new Date '2015-01-06'

    specification =
      item: 'IDPXIDH-7890'
      dates:
        purchase: Date

    doc.should.not.respect specification, { partial: false }


describe 'Nested arrays comparison', ->

  before ->
    redefineChai()

  it 'should validate a simple nested array', ->
    { arr: [5, '34', null, true, 'Matches this RegExp'] }.should.respect { arr: [5, '34', null, Boolean, /regex/i] }

  it 'should not validate a nested array with a different length', ->
    { arr: [5, '34', null, true, 'Matches this RegExp'] }.should.not.respect { arr: [5, '34', null, Boolean] }

  it 'should partially validate an array with keys and length', ->
    { arr: [5, '34', null, true] }.should.respect
      arr:
        0: 5
        3: Boolean
        length: 4

  it 'should not validate an array a wrong length', ->
    { arr: [5, '34', null, true] }.should.not.respect
      arr:
        0: 5
        3: Boolean
        length: 3

  it 'should not validate an array with a wrong key', ->
    { arr: [5, '34', null, true] }.should.not.respect
      arr:
        0: 5
        3: Number
        length: 4

  it 'should validate partially equal objects in nested arrays', ->

    doc =
      _id: '55167a304e067c005e573da1'
      orders: [{
        _id: '55167a304e067c005e573dc0'
        item: 'IDPXIDH-7890'
        qty: 5
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }, {
        _id: '55167a304e067c005e573dc1'
        item: 'IDPXIDH-7950'
        qty: 2
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }]
    specification =
      orders: [{
        item: 'IDPXIDH-7890'
        qty: 5
        dates:
          purchase: Date
      }, {
        item: 'IDPXIDH-7950'
        qty: 2
        dates:
          purchase: Date
      }]

    doc.should.respect specification

  it 'should validate partially equal objects in nested arrays (comparison with keys)', ->

    doc =
      _id: '55167a304e067c005e573da1'
      orders: [{
        _id: '55167a304e067c005e573dc0'
        item: 'IDPXIDH-7890'
        qty: 5
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }, {
        _id: '55167a304e067c005e573dc1'
        item: 'IDPXIDH-7950'
        qty: 2
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }]
    specification =
      orders:
        0:
          item: 'IDPXIDH-7890'
          qty: 5
          dates:
            purchase: Date
        length: 2

    doc.should.respect specification

  it 'should unvalidate unmatching objects in nested arrays', ->

    doc =
      _id: '55167a304e067c005e573da1'
      orders: [{
        _id: '55167a304e067c005e573dc0'
        item: 'IDPXIDH-7890'
        qty: 5
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }, {
        _id: '55167a304e067c005e573dc1'
        item: 'IDPXIDH-7950'
        qty: 2
        dates:
          purchase: new Date '2015-01-05'
          payment: new Date '2015-01-06'
      }]
    specification =
      orders: [{
        item: 'IDPXIDH-7890'
        qty: 5
        dates:
          purchase: Date
      }, {
        item: 'IDPXIDH-7950'
        qty: 3
        dates:
          purchase: Date
      }]

    doc.should.not.respect specification

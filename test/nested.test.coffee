
should = null
respect = require '..'


describe 'Nested objects comparison', ->

  before ->
    delete Object::should
    chai = require 'chai'
    chai.use respect.chaiPlugin()
    should = chai.should()


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

    doc.should.not.respect specification, { partial: false }

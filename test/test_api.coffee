describe "tt-api", ->
  beforeEach ->
    TT.api.accessToken = 'abc'
    sinon.spy($, "ajax")

  afterEach ->
    $.ajax.restore()

  it 'should define the api namespace in the TT object', ->
    TT.api.should.be.a('object')

  it 'should GET an endpoint', ->
    TT.api.get('v1/foo')

    $.ajax.should.have.been.calledWithMatch
      type: 'GET'
      url: 'https://api.tictail.com/v1/foo'
      headers: 'Authorization': 'Bearer abc'

describe "tt-api", ->
  beforeEach ->
    TT.api.accessToken = 'abc'
    sinon.stub($, "ajax")

  afterEach ->
    $.ajax.restore()

  it 'should define the api namespace in the TT object', ->
    TT.api.should.be.a('object')

  describe "can talk to the API", ->
    before ->
      @defaults =
        url: 'https://api.tictail.com/v1/foo'
        headers: 'Authorization': 'Bearer abc'

    it 'should GET an endpoint', ->
      TT.api.get('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'GET'}, @defaults))

    it 'should POST to an endpoint', ->
      TT.api.post('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'POST'}, @defaults))

    it 'should PUT to an endpoint', ->
      TT.api.put('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'PUT'}, @defaults))

    it 'should DELETE to an endpoint', ->
      TT.api.delete('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'DELETE'}, @defaults))

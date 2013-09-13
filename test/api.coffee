describe 'tt-api', ->
  beforeEach ->
    TT.api.accessToken = 'abc'
    sinon.stub($, 'ajax')

  afterEach ->
    $.ajax.restore()

  it 'should define the api namespace in the TT object', ->
    TT.api.should.be.a('object')

  describe 'can talk to the API', ->
    before ->
      @defaults =
        url: 'https://api.tictail.com/v1/foo'
        headers: 'Authorization': 'Bearer abc'
        contentType: 'application/json'

    it 'should GET an endpoint', ->
      TT.api.get('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'GET'}, @defaults))

    it 'should serialize the data parameter', ->
      TT.api.post('v1/foo', {foo: 'bar'})

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'POST', data: '{"foo":"bar"}'}, @defaults))

    it 'should POST to an endpoint', ->
      TT.api.post('v1/foo', '{}')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'POST', data: '{}'}, @defaults))

    it 'should PUT to an endpoint', ->
      TT.api.put('v1/foo', '{}')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'PUT', data: '{}'}, @defaults))

    it 'should DELETE to an endpoint', ->
      TT.api.delete('v1/foo')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'DELETE'}, @defaults))

    it 'should PATCH to an endpoint', ->
      TT.api.patch('v1/foo', '{}')

      $.ajax.should.have.been.calledWithMatch(
        $.extend({type: 'PATCH', data: '{}'}, @defaults))

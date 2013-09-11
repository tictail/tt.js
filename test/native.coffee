describe 'tt-native', ->
  beforeEach ->
    # Change the origin when running the tests so we don't need to remap tictail.com
    TT.native.PARENT_ORIGIN = 'http://127.0.0.1:9000'
    sinon.spy(window.parent, 'postMessage')

  afterEach ->
    window.parent.postMessage.restore()

  it 'should define the native namespace in the TT object', ->
    TT.native.should.be.a('object')

  describe '#init()', ->
    it 'should provide the accessToken to the callback', (done) ->
      TT.native.init(->
        TT.native.accessToken.should.equal('abc123')

        window.parent.postMessage.should.have.been.calledWith(
          JSON.stringify(eventName: 'requestAccess'),
          TT.native.PARENT_ORIGIN
        )

        done()
      )

      # Simulate the protocol that our dashboard uses during the auth dance
      window.postMessage(
        JSON.stringify(eventName: "access", eventData: {accessToken: "abc123"}),
        TT.native.PARENT_ORIGIN
      )

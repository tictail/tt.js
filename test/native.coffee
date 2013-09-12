describe 'tt-native', ->
  beforeEach ->
    TT.native.PARENT_ORIGIN = 'http://127.0.0.1:9000'

    sinon.spy(window.parent, 'postMessage')

  afterEach ->
    window.parent.postMessage.restore()

  it 'should define the native namespace in the TT object', ->
    TT.native.should.be.a('object')

  describe '#init()', ->
    it 'should resolve the promise with the accessToken in place', (done) ->
      TT.native.init()
        .then(=>
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

    it 'should reject the promise if there was an error', (done) ->
      TT.native.init()
        .fail((error) ->
          error.should.equal('some error')
          done()
        )

      # Simulate the protocol that our dashboard uses during the auth dance
      window.postMessage(
        JSON.stringify(eventName: 'error', eventData: {message: 'some error'}),
        TT.native.PARENT_ORIGIN
      )

  describe '#loading', ->
    it 'should trigger the corresponding event in the dashboard', ->
      TT.native.loading()

      window.parent.postMessage.should.have.been.calledWith(
        JSON.stringify(eventName: 'loading'),
        TT.native.PARENT_ORIGIN
      )

  describe '#loaded', ->
    it 'should trigger the corresponding event in the dashboard', ->
      TT.native.loaded()

      window.parent.postMessage.should.have.been.calledWith(
        JSON.stringify(eventName: 'loaded'),
        TT.native.PARENT_ORIGIN
      )

  describe '#reportSize', ->
    beforeEach ->
      $('html')
        .width(50)
        .height(100)

    it 'should report the size of the apps html back to the dashboard', ->
      TT.native.reportSize()

      window.parent.postMessage.should.have.been.calledWith(
        JSON.stringify(eventName: 'reportSize', eventData: {width: 50, height: 100}),
        TT.native.PARENT_ORIGIN
      )

    it 'should respond with its size when a requestSize message is received', (done) ->
      window.postMessage(
        JSON.stringify(eventName: 'requestSize'),
        TT.native.PARENT_ORIGIN
      )

      setTimeout(=>
        window.parent.postMessage.should.have.been.calledWith(
          JSON.stringify(eventName: 'reportSize', eventData: {width: 50, height: 100}),
          TT.native.PARENT_ORIGIN
        )
        done()
      , 1)

  describe '#showStatus', ->
    it 'should trigger the corresponding event in the dashboard', ->
      TT.native.showStatus('$aved')

      window.parent.postMessage.should.have.been.calledWith(
        JSON.stringify(eventName: 'showStatus', eventData: '$aved'),
        TT.native.PARENT_ORIGIN
      )

  describe '#showShareDialog', ->
    it 'should resolve on successful share', (done) ->
      TT.native.showShareDialog('My heading', 'My message')
        .then(->
          window.parent.postMessage.should.have.been.calledWith(
            JSON.stringify(
              eventName: 'showShareDialog',
              eventData: {heading: 'My heading', message: 'My message'}
            ),
            TT.native.PARENT_ORIGIN
          )
          done()
        )

      window.postMessage(
        JSON.stringify(eventName: 'shareDialogShown', eventData: true),
        TT.native.PARENT_ORIGIN
      )

    it 'should reject when the user aborts the sharing process', (done) ->
      TT.native.showShareDialog({heading: 'My heading', message: 'My message'})
        .fail(-> done())

      window.postMessage(
        JSON.stringify(eventName: 'shareDialogShown', eventData: false),
        TT.native.PARENT_ORIGIN
      )

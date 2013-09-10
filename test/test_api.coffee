describe "tt-api", ->
  it 'should define the api namespace in the TT object', ->
    window.TT.api.should.be.a('object')

describe 'tt-native', ->
  it 'should define the native namespace in the TT object', ->
    TT.native.should.be.a('object')

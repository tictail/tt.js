describe 'tt-core', ->
  it 'should define TT on window', ->
    window.TT.should.be.an 'object'

  describe '#noConflict', ->
    tt = null
    beforeEach -> tt = TT
    afterEach -> window.TT = tt

    it 'should return itself', ->
      before = TT
      TT.noConflict().should.equal before

    it 'should restore the previous TT value', ->
      TT.noConflict()
      TT.should.equal 'noConflict test' # Set in test/index.html


describe 'tt-storage', ->
  beforeEach ->
    localStorage['tt-storage'] = JSON.stringify {one: 1, two: 2, three: 3}

  it 'should define the storage namespace on the TT object', ->
    TT.storage.should.be.an 'object'

  it 'should communicate with the API'
  it 'should resolve promises on successful API calls'
  it 'should reject promises on errorous API calls'

  describe '#get', ->
    it 'should return a promise', ->
      TT.storage.get().should.be.a.promise

    it 'should take keys as arguments and resolve with an object ' +
       'containing the stored values for those', (done) ->
        TT.storage.get('one', 'two').then (storage) ->
          storage.should.deep.equal {one: 1, two: 2}
          done()

    it 'should resolve with an object with undefined as the value for the ' +
       'unset keys', (done) ->
        TT.storage.get('three', 'four').then (storage) ->
          storage.should.deep.equal {three: 3, four: undefined}
          done()

  describe '#set', ->
    it 'should return a promise', ->
      TT.storage.set().should.be.a.promise

    it 'should take an object as the argument and update or set the stored ' +
       'values', (done) ->
        TT.storage.set({one: 2, two: 1}).then ->
          JSON.parse(localStorage['tt-storage'])
            .should.deep.equal {one: 2, two: 1, three: 3}
          done()

  describe '#remove', ->
    it 'should return a promise', ->
      TT.storage.remove().should.be.a.promise

    it 'should take keys as arguments and remove them from the storage', (done) ->
      TT.storage.remove('one', 'two').then ->
        JSON.parse(localStorage['tt-storage']).should.deep.equal {three: 3}
        done()

  describe '#clear', ->
    it 'should return a promise', ->
      TT.storage.clear().should.be.a.promise

    it 'should remove everything from storage', (done) ->
      TT.storage.clear().then ->
        localStorage.should.not.have.property 'tt-storage'
        done()

  # This is only relevant until we move the storage away from localStorage
  describe 'localStorage storage', ->
    it 'should handle localStorage["tt-storage"] = "null"', (done) ->
      localStorage['tt-storage'] = 'null'
      TT.storage.get('three').then (storage) ->
        storage.should.deep.equal {three: undefined}
        done()

    it 'should handle unparsable JSON', (done) ->
      localStorage['tt-storage'] = "Wait a minute, this isn't JSON!"
      TT.storage.get('three').then (storage) ->
        storage.should.deep.equal {three: undefined}
        done()

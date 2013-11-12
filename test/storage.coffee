describe 'tt-storage', ->
  it 'should define the storage namespace on the TT object', ->
    TT.storage.should.be.a 'object'

  it 'should communicate with the API'
  it 'should resolve promises on successful API calls'
  it 'should reject promises on errorous API calls'

  describe '#get', ->
    it 'should return a promise'

    describe 'without arguments', ->
      it 'should resolve with the complete storage object'

      it 'should resolve with an empty object if the storage is empty'

    describe 'with one or more arguments', ->
      it 'should take keys as arguments and resolve with an object ' +
         'containing the stored values for those'

      it 'should resolve with an object with undefined as the value for the ' +
         'unset keys'

  describe '#set', ->
    it 'should return a promise'

    it 'should take an object as the argument and update or set the stored ' +
       'values'

    it 'should resolve with no arguments'

  describe '#remove', ->
    it 'should return a promise'
    it 'should take keys as arguments and remove them from the storage'
    it 'should resolve with no arguments'

  describe '#clear', ->
    it 'should return a promise'
    it 'should remove everything from storage'
    it 'should resolve with no arguments'

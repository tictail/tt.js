helpers = (chai, utils) ->
  Assertion = chai.Assertion

  Assertion.addProperty 'promise', ->
    @assert !!@_obj.promise,
      'expected #{this} to be a Promise',
      'expected #{this} to not be a Promise'

chai.use helpers
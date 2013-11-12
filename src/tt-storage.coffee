window.TT = {} unless window.TT

class Storage
  _parse: (json) ->
    try
      return JSON.parse json
    catch e
      return {}

  request: ->
    deferred = $.Deferred()
    setTimeout (-> deferred.resolve()), 0
    deferred

  get: (args...) =>
    deferred = $.Deferred()

    @request().then =>
      storage = @_parse localStorage['tt-storage']

      result = {}
      result[key] = storage[key] for key in args

      deferred.resolve result

    deferred

  set: (data) =>
    deferred = $.Deferred()

    @request().then =>
      storage = @_parse localStorage['tt-storage']
      storage[key] = value for key, value of data
      localStorage['tt-storage'] = JSON.stringify storage

      deferred.resolve()

    deferred

  remove: (args...) ->
    deferred = $.Deferred()

    @request().then =>
      storage = @_parse localStorage['tt-storage']
      delete storage[key] for key in args
      localStorage['tt-storage'] = JSON.stringify storage

      deferred.resolve()

    deferred

  clear: ->
    deferred = $.Deferred()

    @request().then =>
      delete localStorage['tt-storage']
      deferred.resolve()

    deferred

window.TT.storage = new Storage
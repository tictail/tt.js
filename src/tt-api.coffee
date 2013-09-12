window.TT = {} unless window.TT

###*
@class TT.api
###
class API
  _url: "https://api.tictail.com"

  ###*
  Access token of the store for which this app is installed in.

  @property accessToken
  ###
  accessToken: null


  ###*
  Proxy to `$.ajax` with the `contentType` and `headers` set.

  @method ajax
  @param {Object} options The standard options that you would give `$.ajax`
  ###
  ajax:(options) ->
    defaults =
      url: "#{@_url}/#{options.endpoint}"
      contentType: 'application/json'
      headers:
        Authorization: "Bearer #{@accessToken}"

    $.ajax $.extend(true, defaults, options)


  ###*
  Shorthand for performing `GET` requests to the API.

  @method get
  @param {String} endpoint The endpoint to get
  ###
  get: (endpoint) ->
    @ajax {endpoint: endpoint, type: 'GET'}

  ###*
  Shorthand for performing `POST` requests to the API.

  @method post
  @param {String} endpoint The endpoint to post against
  @param {String} data JSON to send to the API
  ###
  post: (endpoint, data) ->
    @ajax {endpoint: endpoint, data: data, type: 'POST'}


  ###*
  Shorthand for performing `PUT` requests to the API.

  @method put
  @param {String} endpoint The endpoint to put against
  @param {String} data JSON to send to the API
  ###
  put: (endpoint, data) ->
    @ajax {endpoint: endpoint, data: data, type: 'PUT'}


  ###*
  Shorthand for performing `DELETE` requests to the API.

  @method delete
  @param {String} endpoint The endpoint to delete against
  ###
  delete: (endpoint) ->
    @ajax {endpoint: endpoint, type: 'DELETE'}

  ###*
  Shorthand for performing `PATCH` requests to the API.

  @method patch
  @param {String} endpoint The endpoint to patch against
  @param {String} data JSON to send to the API
  ###
  patch: (endpoint, data) ->
    @ajax {endpoint: endpoint, data: data, type: 'PATCH'}

window.TT.api = new API

unless window.tt
  window.tt = {}

class API
  url: "https://api.tictail.com"

  accessToken: null

  ajax:(options) ->
    defaults =
      url: "#{@url}/#{options.endpoint}"
      contentType: 'application/json'
      headers:
        Authorization: "Bearer #{@accessToken}"

    $.ajax $.extend(true, defaults, options)

  get: (endpoint) ->
    @ajax {endpoint: endpoint, type: 'GET'}

  post: (endpoint, data) ->
    @ajax {endpoint: endpoint, data: data, type: 'POST'}

  put: (endpoint, data) ->
    @ajax {endpoint: endpoint, data: data, type: 'PUT'}

  delete: (endpoint) ->
    @ajax {endpoint: endpoint, type: 'DELETE'}

window.tt.api = new API

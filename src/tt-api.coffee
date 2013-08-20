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

  get: (endpoint, options...) ->
    defaults = {endpoint: endpoint}
    @ajax $.extend(true, defaults, options)

window.tt.api = new API

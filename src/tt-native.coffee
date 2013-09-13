window.TT = {} unless window.TT

###*
@class TT.native
###
class Native
  PARENT_ORIGIN: "https://tictail.com"

  ###*
  You should not need to use this access token when performing calls to the
  API using `TT.api`. However, it could be a good idea to save this access
  token if you plan to call the API at a later time, i.e. to push feed card
  items.

  @property accessToken
  ###
  accessToken: null

  constructor: ->
    @_events = $ {}
    @_events.on "requestSize", @reportSize

    @_configurePostMessage()

  _configurePostMessage: ->
    $(window).on "message", (event) =>
      event = event.originalEvent
      return unless event.origin is @PARENT_ORIGIN

      try
        data = JSON.parse event.data
      catch e
        return

      @_events.trigger data.eventName, data.eventData

  ###*
  This method is the magic entry point to native apps, this method initializes
  tt.js by performing the handshake with the Tictail Dashboard and gives the
  methods inside `TT.api` access to talk to the API.

  @method init
  @return {Promise} A promise that will resolve when the handshake was successful.
  ###
  init: ->
    deferred = $.Deferred()

    @_trigger "requestAccess"
    @_events.one "access", (e, {accessToken}) =>
      @accessToken = accessToken

      if TT.api?
        TT.api.accessToken = @accessToken

      @loaded()

      deferred.resolve()

    @_events.one "error", (event, {message}) =>
      @accessToken = null

      if TT.api?
        TT.api.accessToken = @accessToken

      deferred.reject(message)

    return deferred

  ###*
  Show a small loading spinner inside the Tictail Dashboard. This method
  is useful for providing feedback to the user if your app is doing something
  time consuming, i.e. fetching data over the network. Make sure to call
  `TT.native.loaded()` when your app has finished with its task at hand.

  @method loading
  ###
  loading: => @_trigger "loading"

  ###*
  Dismisses the small loading spinner inside the Tictail Dashboard triggered
  by `TT.native.loading`.

  @method loaded
  ###
  loaded: => @_trigger "loaded"

  ###*
  Reports the app size back to the Tictail Dashboard. Make sure to always
  call this method when the size of your app changes inside the DOM. This
  is used when your app is displayed inside the Tictail Feed. As your app
  is displayed inside an iframe we need to know the size of your app.

  @method reportSize
  ###
  reportSize: =>
    $el = $("html")
    width = $el.outerWidth()
    height = $el.outerHeight()

    @_trigger "reportSize", {width: width, height: height}

  ###*
  Show the share dialog in the Tictail Dashboard. This share dialog is a
  way for your app to share a message in social media on behalf of the user.

  @method showShareDialog
  @param {String} heading The heading of the share dialog. This should be
  a short text describing why the user is presented to share something.
  @param {String} message A prefilled message that the user is about to share,
  the user will always have the possibility to change what is about to be
  shared.
  @return {Promise} A promise that will resolve if the user decides to share
  your message or rejects if the user decideds to abort the sharing process.
  ###
  showShareDialog: (heading, message) ->
    deferred = $.Deferred()

    @_trigger "showShareDialog", {
      heading: heading
      message: message
    }

    @_events.one "shareDialogShown", (event, shared) ->
      if shared
        deferred.resolve()
      else
        deferred.reject()

    return deferred


  ###*
  Use this method to show a message to the user inside the Tictail Dashboard.
  This could be used to show the results of actions inside your application,
  i.e. a short "Saved" when the users data have been saved.

  @method showStatus
  @param {String} message The short message to show to the user.
  ###
  showStatus: (message) ->
    @_trigger "showStatus", message

  _trigger: (eventName, eventData) ->
    message = JSON.stringify eventName: eventName, eventData: eventData
    window.parent.postMessage message, @PARENT_ORIGIN

window.TT.native = new Native

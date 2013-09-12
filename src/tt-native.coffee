window.TT = {} unless window.TT

class Native
  PARENT_ORIGIN: "https://tictail.com"

  constructor: ->
    @accessToken = null

    @_events = $ {}
    @_events.on "requestSize", @reportSize

    @_setupMessagingEvents()

  # Initalize TT.js and call the callback with the current store when finished.
  # This should ideally be done before the rest of the application is loaded, e.g
  # TT.init(MyApp.init).
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


  loading: => @_trigger "loading"

  loaded: => @_trigger "loaded"

  # Report the size to the parent frame so that the iframe containing this
  # app is resized.
  reportSize: (options) =>
    $el = $("html")
    width = $el.outerWidth()
    height = $el.outerHeight()

    @_trigger "reportSize", {width: width, height: height}

  # Show the Tictail dashboard share dialog with the given
  # heading and message.
  showShareDialog: (options) ->
    deferred = $.Deferred()

    @_trigger "showShareDialog", {
      heading: options.heading
      message: options.message
    }

    @_events.one "shareDialogShown", (event, shared) ->
      if shared
        deferred.resolve()
      else
        deferred.reject()

    return deferred


  showStatus: (label) ->
    @_trigger "showStatus", label

  # Trigger an event on the parent frame
  _trigger: (eventName, eventData) ->
    message = JSON.stringify eventName: eventName, eventData: eventData
    window.parent.postMessage message, @PARENT_ORIGIN
    this

  # Convert incoming messages to their own events on the @_events object,
  # assuming every message is a JSON string containing the keys eventName
  # and eventData.
  _setupMessagingEvents: ->
    $(window).on "message", (e) =>
      return unless e.originalEvent.origin is @PARENT_ORIGIN

      try
        data = JSON.parse e.originalEvent.data
      catch e
        return

      @_events.trigger data.eventName, data.eventData

window.TT.native = new Native

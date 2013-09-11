unless window.TT
  window.TT = {}

class Native
  PARENT_ORIGIN: "https://tictail.com"

  accessToken: null

  _events: $ {}

  # Initalize TT.js and call the callback with the current store when finished.
  # This should ideally be done before the rest of the application is loaded, e.g
  # TT.init(MyApp.init).
  init: () ->
    @_setupMessagingEvents()

    deferred = $.Deferred()

    @_events.on "requestSize", @reportSize
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
  # app is resized. The options parameter can either contain a width and
  # height property, or an element property containing a jQuery compatible
  # selector string. If called without arguments, the outer size of the <html>
  # element is reported.
  reportSize: (options) ->
    width = height = 0
    if options?.width and options?.height
      {width, height} = options
    else
      $el = $(options?.element or "html")
      width = $el.outerWidth()
      height = $el.outerHeight()

    @_trigger "reportSize", {width: width, height: height}

  # Show the Tictail dashboard share dialog with the given
  # heading and message. The given onComplete function is called
  # with a Boolean indicating whether the user clicked share (true)
  # or cancelled (false).
  showShareDialog: (options) ->
    @_trigger "showShareDialog", {
      heading: options.heading
      message: options.message
    }

    @_events.one "shareDialogShown", (e, data) ->
      options.onComplete? data

    this

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

window.TT.Native = Native
window.TT.native = new Native

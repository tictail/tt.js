###*
@class TT
###
class TT
  $: null
  _moduleQueue: []

  constructor: ->
    @_TT = window.TT

  init: ($) ->
    @$ = $
    @addModule(item.name, item.Module) while (item = @_moduleQueue.pop())

  addModule: (name, Module) =>
    if @$
      @[name] = new Module @$
    else
      @_moduleQueue.push name: name, Module: Module

  ###*
   Reset the value of window.TT to what it was previously.

   @method noConflict
   @return {Object} A reference to the TT.js object.
  ###
  noConflict: =>
    window.TT = @_TT
    this

tt = new TT

if typeof define is 'function' and define.amd
  define 'tt', ['jquery'], ($) ->
    tt.init $
    tt
else
  tt.init window.jQuery
  window.TT = tt

module.exports = tt

###*
@class TT
###
class TT
  constructor: ->
    @_TT = window.TT

  ###*
   Reset the value of window.TT to what it was previously.

   @method noConflict
   @return {Object} A reference to the TT.js object.
  ###
  noConflict: =>
    window.TT = @_TT
    this

if typeof define is 'function' and define.amd
  define 'tt-core', -> new TT
else
  window.TT = new TT

module.exports = window.TT


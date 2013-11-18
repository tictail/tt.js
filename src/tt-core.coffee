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

tt = new TT
if typeof define is 'function' and define.amd
  define 'tt-core', -> tt
else
  window.TT = tt

module.exports = tt


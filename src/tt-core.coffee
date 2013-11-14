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
if typeof window.define is 'function' && window.define.amd
  window.define 'tt', -> tt
else
  window.TT = tt

module.exports = tt


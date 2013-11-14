class TT
  constructor: ->
    @_TT = window.TT

  noConflict: =>
    window.TT = @_TT
    this

tt = new TT
if typeof window.define is 'function' && window.define.amd
  window.define 'tt', -> tt
else
  window.TT = tt

module.exports = tt


class TT

tt = new TT
if typeof window.define is 'function' && window.define.amd
  window.define 'tt', -> tt
else
  window.TT = tt

module.exports = tt


TT = require './tt-core'
require './tt-api'
require './tt-native'
require './tt-storage'

if typeof define is 'function' and define.amd
  define 'tt', [
    'tt-core'
    'tt-api'
    'tt-native'
    'tt-storage'
  ], (tt) -> tt
else
  window.TT = TT

#Immutable class for 2d position coordinates
R   = require 'ramda'
util = require './util'

#find the midpoint between 2 numbers
midpoint = R.curry (a, b) -> a + ((b - a) / 2)

_combine = R.curry (comb, vect) -> new Vector2 comb(@x, vect.x), comb(@y, vect.y)

class Vector2
    constructor: (x, y) ->
        _x = if isNaN(x) then 0 else x
        _y = if isNaN(y) then 0 else y
        @x = _x | 0
        @y = Math.floor _y
        Object.freeze this

    map: (fn) -> new Vector2 fn(@x), fn(@y)

    #combine with another vector using passed function
    combine: _combine
    subtract: _combine R.subtract
    multiply: _combine R.multiply
    divide: _combine R.divide
    midpoint: _combine midpoint
    sum: _combine R.sum
    translate: R.curry (x, y) -> new Vector2 @x + x, @y + y
    hypot: -> util.hypot @x, @y


module.exports = Vector2
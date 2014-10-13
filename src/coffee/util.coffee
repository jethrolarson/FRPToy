R = require 'ramda'
#Extend Math object as needed
module.exports = {
    sq: (a) -> a * a
    #x = √a^2 + b^2
    hypot: (a, b) -> Math.sqrt @sq(a) + @sq(b)
    isNumber: (value) ->
        typeof value == 'number' or value and typeof value == 'object' and toString.call(value) == '[object Number]' or false
    isNaN: (n) -> Math.isNumber(value) && value isnt +value
    max: R.curry Math.max, 2
}
#immutable class for 2d position coordinates
class Vector2
    constructor: (x, y) ->
        @x = Math.floor x
        @y = Math.floor y
        Object.freeze this
    sub: (vect) -> new Vector2 @x - vect.x, @y - vect.y
    sum: (vect) -> new Vector2 @x + vect.x, @y + vect.y
    translate: (x, y) -> new Vector2 @x + x, @y + y

module.exports = Vector2
#largely a coffee port from found easing functions on the internet.

R   = require 'ramda'

baseEasings = {}
$.each [
  "Quad"
  "Cubic"
  "Quart"
  "Quint"
  "Expo"
], (i, name) ->
    baseEasings[name] = (p) ->
        Math.pow p, i + 2
    return

R.extend baseEasings, {
    Sine: (p) ->
        1 - Math.cos(p * Math.PI / 2)

    Circ: (p) ->
        1 - Math.sqrt(1 - p * p)

    Elastic: (p) ->
        if p is 0 or p is 1
            p
        else
            -Math.pow(2, 8 * (p - 1)) * Math.sin(((p - 1) * 80 - 7.5) * Math.PI / 15)

    Back: (p) ->
        p * p * (3 * p - 2)

    Bounce: (p) ->
        pow2 = undefined
        bounce = 4
        continue  while p < ((pow2 = Math.pow(2, --bounce)) - 1) / 11
        1 / Math.pow(4, 3 - bounce) - 7.5625 * Math.pow((pow2 * 3 - 2) / 22 - p, 2)
}

R.each baseEasings, (name, easeIn) ->
    $.easing["easeIn" + name] = easeIn
    $.easing["easeOut" + name] = (p) ->
        1 - easeIn(1 - p)

    $.easing["easeInOut" + name] = (p) ->
        if p < 0.5
            easeIn(p * 2) / 2
        else
            1 - easeIn(p * -2 + 2) / 2)

    return

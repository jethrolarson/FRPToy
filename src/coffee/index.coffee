"use Strict"
Bacon   = require 'baconjs'
_       = require 'lodash'
fn      = require './fn'
Vector2 = require './Vector2'

_.mixin fn

#enum of keyCodes
KEYS = 
    left: 37
    up: 38
    right: 39
    down: 40


canvasEl = document.getElementById 'c'
c = canvasEl.getContext '2d'

canvasPos = (e)-> new Vector2 canvasEl.offsetLeft, canvasEl.offsetTop

#es that vends frames
frames = Bacon.fromBinder (sink) ->
  request =
    window.requestAnimationFrame        or
    window.webkitRequestAnimationFrame  or
    window.mozRequestAnimationFrame     or
    window.oRequestAnimationFrame       or
    window.msRequestAnimationFrame      or
    (f) -> window.setTimeout(f, 1000 / 60)
  subscribed = true
  handler = ->
    if subscribed
      sink()
      request handler
  request handler
  ->
    subscribed = false

esResize = Bacon.fromEventTarget window, 'resize'
esCanvasPos = esResize
    .debounce 200
    .map canvasPos
    .toProperty canvasPos()

#size the canvas to window
esCanvasPos.onValue (v)->
    canvasEl.width = window.innerWidth
    canvasEl.height = window.innerHeight

esKeyDown = Bacon.fromEventTarget window, 'keyup'
    .map '.keyCode'
esKeyUp = Bacon.fromEventTarget window, 'keydown'
    .map '.keyCode'

createKeyStream = (keyCode)-> 
    esKeyUp.filter _.partial _.eq, keyCode

mousewheel = Bacon.fromEventTarget(document, 'mousewheel')

#up and down to change the hue
colorStep = 30
startingHue = 0
esHueInc = createKeyStream(KEYS.up).map colorStep
esHueDec = createKeyStream(KEYS.down).map -colorStep
hue = esHueInc.merge(esHueDec)
    .merge mousewheel
        .map (e)-> e.wheelDeltaX / 2
    .scan startingHue, _.sum

#left and right to change the size of the square
sizeStep = 5
startSize = 40
esSizeInc = createKeyStream(KEYS.right).map sizeStep
esSizeDec = createKeyStream(KEYS.left).map -sizeStep
size = esSizeDec.merge(esSizeInc)
    .merge mousewheel
        .map (e)-> e.wheelDeltaY / 2
    .scan startSize, _.compose _.partial(Math.max, 5), _.sum 



mouseDown = Bacon.fromEventTarget(window, 'mousedown').map true
mouseUp = Bacon.fromEventTarget(window, 'mouseup').map false
mousePressed = mouseDown.merge mouseUp
    .toProperty false

mousePos = Bacon.fromEventTarget window, 'mousemove'
    .combine canvasPos, (e, c) ->
        new Vector2(
            e.pageX,
            e.pageY
        )
        .sub c() #I don't know why this is the function and not the vector.

esDraw = mousePos
    .combine hue, (p, h) ->
        pos: p
        hue: h
    .combine size, (p, s)-> _.extend p, s: s
    #only draw when mouse is down
    # .filter mousePressed

esDraw.onValue (v) ->
        #center the square on the mouse pos
        offsetPos = v.pos.translate(-v.s / 2, -v.s / 2)

        c.beginPath()
        c.strokeStyle = "hsl(#{v.hue}, 20%,50%)"
        c.rect offsetPos.x, offsetPos.y, v.s, v.s
        c.stroke()
        c.closePath()

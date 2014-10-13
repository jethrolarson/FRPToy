"use Strict"

###

    I recognize that there's not a lot of structure to this project. I wrote it because I wanted something fun to play with while experimenting with Functional Reactive Programming.
    I won't claim to be an expert at it, but while working on this project the concepts finally started clicking for me.

    What does this toy do?
    1. gulp the project to start the server (npm install gulp -g; gulp)
    2. navigate to  http://localhost:8000/
    3. wiggle mouse on the screen, try the mouse wheel, try different speeds. Try to make something pretty.

    Sorry there's not much comments below, if I were to release this open source I'd clean it up more.

###


Bacon   = require 'baconjs'
Vector2 = require './Vector2'
clock = require './clock'
R = require "ramda"
util = require './util'

#enum of keyCodes
KEYS = {
    left: 37
    up: 38
    right: 39
    down: 40
}

canvasEl = document.getElementById 'c'
c = canvasEl.getContext '2d'
DPR = window.devicePixelRatio
canvasPos = (e) -> new Vector2 canvasEl.offsetLeft, canvasEl.offsetTop
divideBy = R.flip R.divide
#event stream that vends frames
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

# map the timesteam to time in milliseconds
esTime = frames.map -> clock.getTime()
#window resize event, debounced to prevent excessive calls
esResize = Bacon.fromEventTarget(window, 'resize').debounce 200
#map resize to canvas position so the render maths are relative to the canvas not the window.
esCanvasPos = esResize
    .map canvasPos
    .toProperty canvasPos()

getWindowSize = -> {
    height: window.innerHeight
    width: window.innerWidth
}

#size the canvas to window
esWindowSize = esResize.map getWindowSize
    .toProperty do getWindowSize

#Update the canvas size on window resize
esWindowSize.onValue (v) ->
    canvasEl.width = v.width * DPR
    canvasEl.height = v.height * DPR
    canvasEl.style.width  = v.width + 'px'
    canvasEl.style.height = v.height + 'px'

esKeyDown = Bacon.fromEventTarget window, 'keyup'
    .map '.keyCode'
# esKeyUp = Bacon.fromEventTarget window, 'keydown'
#     .map '.keyCode'

createKeyStream = (keyCode) ->
    esKeyDown.filter R.eq(keyCode)

mousewheel = Bacon.fromEventTarget(document, 'mousewheel')

colorStep = 30 #how much a key press should adjust color
startingHue = 0 #red (hsl)

#right and left keys change the hue
esHueInc = createKeyStream(KEYS.right).map colorStep
esHueDec = createKeyStream(KEYS.left).map -colorStep

#hue now controlled by cycle over time
#esWheelX = mousewheel.map (e)-> e.wheelDeltaX / 2
#mousewheel controls hue
#esWindowHeight = esWindowSize.map '.height'
# hue = esHueInc.merge(esHueDec)
#     .merge esWheelX
#     .combine esWindowHeight, (inc, h)-> if inc > h then 0 else inc
#     .scan startingHue, R.sum

# hue changes over time
hue = esTime.map (time) -> time / 10 % 360

#up and down key change the size of the square
sizeStep = 5
startSize = 40
minSize = 5
esSizeInc = createKeyStream(KEYS.up).map sizeStep
esSizeDec = createKeyStream(KEYS.down).map -sizeStep
esWheelY = mousewheel.map ".wheelDeltaY"
size = esSizeDec
    #join both resize event streams
    .merge esSizeInc
    #divide mousewheel values by 4 so it doesn't grow too fast
    .merge esWheelY.map divideBy 4
    #scan over size changes and add the params, but set a min size
    .scan startSize, R.pipe(R.add, util.max minSize)

#mouse down used to start the paint, but it's more fun if it's constantly painting.
# mouseDown = Bacon.fromEventTarget(window, 'mousedown').map true
# mouseUp = Bacon.fromEventTarget(window, 'mouseup').map false
# mousePressed = mouseDown.merge mouseUp
#     .toProperty false

mousePos = Bacon.fromEventTarget window, 'mousemove'
    .merge Bacon.fromEventTarget window, 'touchmove' #include touch support, TODO test this
    .combine esCanvasPos, (e, c) ->
        new Vector2(e.pageX, e.pageY)
        .map R.multiply DPR
        .subtract c

DEFAULT_VELOCITY = {
    pos: new Vector2 0, 0
    time: new Date().getTime()
    vel: new Vector2 0, 0
}

#create mouseVelocity stream by scanning over mousePosition stream
mouseVelocity = mousePos.combine esTime, (v, time) -> { pos: v, time: time }
    .scan DEFAULT_VELOCITY, (o1, o2) ->
        dPos = o2.pos.subtract o1.pos

        #If dTime would be 0 set to 1 so we don't divide by zero
        dTime = o2.time - o1.time || 1
        vel = dPos.map divideBy dTime #px / ms
        return {
            pos: o2.pos
            time: o2.time
            vel: o1.vel.midpoint vel #set vel to the midpoint between last and current (lazy easing)
        }

#map luminocity to velovity
#TODO apply easing function or something so it's more smooth.
lum = mouseVelocity.map (p) -> Math.min(p.vel.hypot() * 10, 100)

#combine the streams together to create a master object that we'll drive the draw function from
esDraw = mouseVelocity
    .combine hue, (p, h)  -> R.mixin p, { hue: h }
    .combine size, (p, s) -> R.mixin p, { s: s }
    .combine lum, (p, l)  -> R.mixin p, { lum: l }
    #.filter (p) -> p.vel?.hypot() > 0 #ignore small movements for perf? Nah, caused perceived jank.


#Finally draw to the canvas!
esDraw.onValue (v) ->
    #center the square on the mouse pos
    offsetPos = v.pos.translate  -v.s / 2, -v.s / 2

    do c.beginPath
    c.fillStyle = "hsl(#{v.hue}, 40%, #{v.lum}%)"
    c.rect offsetPos.x, offsetPos.y, v.s, v.s
    do c.fill
    do c.closePath


###TODO
* draw only on animation frames
* adjust the velocity logic to make the color transitions smoother
* Look into the garbage collection issues. (sawtooth in memory profiler)
###


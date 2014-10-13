# This singleton object can be swapped out to debug time.
module.exports = {
    getTime: ->
        if window.performance
            window.performance.now()
        else
            new Date().getTime()
}

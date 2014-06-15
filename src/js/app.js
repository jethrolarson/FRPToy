var app = {
    init: function(){

    },
    start: function(){
        render();
    },
    render: function(){

        getFrame(render);
    },
    getFrame: function (callback) {
        return webkitRequestAnimationFrame(callback);
    }
};

app.init();
app.start();
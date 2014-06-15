PATHING = {
    NORMAL: 0,
    IMPASSIBLE: 1,
    SLOW: 2
};

var Grass = M.props({},{
    name: "Grass",
    cover: 1,
    pathing: PATHING.NORMAL
});
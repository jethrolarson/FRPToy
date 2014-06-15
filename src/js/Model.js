"use Strict";

//What if we reject typical OOP standards of having functions bound to objects
//and instead classes are just packages of methods and a set of standards for binding contexts
//and decorating objects

//Rules:
//1. Always pass context as first attribute
//2. Transformations can be made in bulk
//3. Transformations always return context
var M = {};
M.props = function(cxt, props){
    cxt = cxt || {};
    cxt.props = props;
    cxt.events = {};
    return cxt;
};

M.get = function(cxt, key) {
    return key ? cxt.props[key] : cxt.props;
};


M.set = function(cxt, key, val, quiet){
    
    if(!cxt.props){
        cxt.props = {};
    }
    var prevVal = cxt.props[key];
    cxt.props[key] = val;
    if(cxt._events && !quiet && prevVal != val){
        Events.trigger(cxt,'change:'+key, val);
    }
    return cxt;
};


exports = M;

//Usage:
// Events(obj,{
//     change: handler
// })

Events = function(cxt, events){
    cxt._events = cxt._events || {};
    for(var eventName in events){
        if(!cxt._events[eventName]){
            cxt._events[eventName] = [];
        }
        cxt._events[eventName].push(events[eventName]);
    }
    return cxt;
};

// Usage:
// Events.trigger(ob,'change', arbitrary_data)
Events.trigger = function(cxt, eventName, data){
    if(!cxt._events){return;}
    var i =0,
        len = cxt._events[eventName] && cxt._events[eventName].length;
    for(;i<len;i++){
        cxt._events[eventName][i].call(cxt, data);
    }
};
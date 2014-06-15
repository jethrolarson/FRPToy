eventM = {}
Events(eventM,{
    'change:dog': function(k){
        console.log('change:dog',k)
        console.assert(k == 'banana');
    }
});

M.set(eventM,'dog','banana');


console.assert(M.get(eventM,'dog') == 'banana');
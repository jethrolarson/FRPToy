
m = M.props({},{a:1,b:2,c:3});

console.log('Model init');
console.assert(JSON.stringify(M.get(m)),JSON.stringify({a:1,b:2,c:3}));
           
console.log('Model set/get');

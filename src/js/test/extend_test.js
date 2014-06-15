console.log('extend');
console.assert(JSON.stringify(extend({a:1,b:2,c:3}, {a:2,d:4})),JSON.stringify({a:2,b:2,c:3,d:4}) );
console.assert(JSON.stringify(extend({a:1,c:3},{b:2}, {a:2,d:4})),JSON.stringify({a:2,b:2,c:3,d:4}) );
//TODO more extensive tests
var slice = function(ar){
        return Array.prototype.slice.call(ar);
    },
    //extend objects with the properties of following ones passed in. 
    //You can pass as many arguments as you want and all the objects get
    //collapsed right-to-left.
    extend = function(ob1, ob2){
        ob1 = ob1 || {};
        if(arguments.length > 2){
            //call this recursively
            ob2 = this.extend.apply(this, slice.call(arguments, 1));
        }
        if(ob2){
            for(var k in ob2){
                ob1[k] = ob2[k];
            }
        }
        return ob1;
    };
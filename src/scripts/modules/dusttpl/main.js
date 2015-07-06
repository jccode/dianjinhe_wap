
define(['jquery', 'underscore', 'common'], function($, _, c) {
    
    return function() {

        var locals = {
            friends: [
                { name: "Barack Obama", age: 52 },
                { name: "Joe Biden", age: 71 }
            ]
        };
        
        c.render('container', 'views/hello', locals);
        
    };

});

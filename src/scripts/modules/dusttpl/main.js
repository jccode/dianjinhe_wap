
define(['jquery', 'underscore', 'common', 'text!/views/body.html'], function($, _, c, tpl) {
    
    return function() {
        // console.log(tpl);
        c.render('container', tpl);
    };

});



define(['jquery', 'underscore', 'common', 'text!/views/home.html'], function($, _, c, tpl) {

    
    return function () {
        c.render('root', tpl);
    };

});

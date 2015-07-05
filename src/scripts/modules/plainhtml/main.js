
define(['jquery', 'underscore', 'common', 'text!/views/licai.html'], function($, _, c, tpl) {


    return function() {
        c.render('root', tpl);
    };
});

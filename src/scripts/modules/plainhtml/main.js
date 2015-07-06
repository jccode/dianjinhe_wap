
define(['jquery', 'underscore', 'common', 'text!/views/plain.html'], function($, _, c, tpl) {


    return function() {
        c.renderHtml('root', tpl);
    };
});

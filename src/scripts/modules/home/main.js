

define(['jquery', 'underscore', 'text!/views/home.html'], function($, _, tpl) {

    return function () {
        $("#root").html(tpl);
    };

});

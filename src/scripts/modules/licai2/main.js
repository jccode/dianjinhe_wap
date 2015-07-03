
define(['jquery', 'underscore', 'text!/views/licai.html'], function($, _, tpl) {

    console.log('licai2');

    return function() {
        $("#rootView").html(tpl);
    };
});

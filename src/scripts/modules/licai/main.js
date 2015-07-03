
define(['jquery', 'underscore', 'text!/views/licai.html'], function($, _, tpl) {

    console.log('licai');

    return function() {
        $("#rootView").html(tpl);
    };
});


define(['jquery', 'underscore', 'text!/views/body.html'], function($, _, tpl) {
    
    return function() {
        console.log(tpl);
        $("#container").html(tpl);
    };

});

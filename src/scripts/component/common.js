
define(['jquery', 'underscore'], function($, _) {

    var render = function(name, tpl, context) {
        $("[data-view='"+name+"']").html(tpl);
    };
    
    return {
        webroot: '/dianjinhe',
        render: render
    };
});

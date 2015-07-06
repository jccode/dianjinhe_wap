
define(['require', 'jquery', 'underscore', 'views'], function(require, $, _, views) {

    var render = function(view, tplName, context) {
        require([tplName], function(tplFn) {
            tplFn(context, function(err, out) {
                renderHtml(view, out);
            });
        });
    };

    var renderHtml = function(view, tpl) {
        $("[data-view='"+view+"']").html(tpl);
    };
    
    return {
        webroot: '/dianjinhe',
        render: render,
        renderHtml: renderHtml
    };
});

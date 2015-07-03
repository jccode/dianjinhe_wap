/*jslint regexp: true, nomen: true, sloppy: true */
/*global requirejs, require, define */


define([
    'jquery',
    'underscore',
    'backbone',
    'router'
], function ($, _, Backbone, router) {

    'use strict';

    // Add special modules routing here

    router.route("sample/*", "sample", function () {
        this.loadModule("modules/sample/main");
    });

    router.route("licai/*", "licai", function () {
        this.loadModule("modules/licai/main");
    });

    
    var root = $("[data-main][data-root]").data("root");
    root = root ? root : '/';

    return {
        initialize: function () {

            /*
            Backbone.history.start({
                pushState: true,
                root: root
            });
             */

            Backbone.history.start();
        }
    };
});




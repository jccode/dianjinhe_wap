/*jslint regexp: true, nomen: true, sloppy: true */
/*global requirejs, require, define */


define(["underscore", "backbone"], function (_, Backbone) {

    'use strict';

     // Router
    var Router = Backbone.Router.extend({


        routes: {
            // "": "home",
            // "sample": "sample",
            // "licai": "licai",
            // "licai/:id": "licaiDetail"
            "*actions": "defaultAction"
        },

        
        loadModule: function (module) {
            require([module], function (module) {
                module();
            });
        },

        current: function() {
            var Router = this,
                fragment = Backbone.history.fragment,
                routes = _.pairs(Router.routes),
                route = null, params = null, matched;

            matched = _.find(routes, function(handler) {
                route = _.isRegExp(handler[0]) ? handler[0] : Router._routeToRegExp(handler[0]);
                return route.test(fragment);
            });

            if(matched) {
                // NEW: Extracts the params using the internal
                // function _extractParameters 
                params = Router._extractParameters(route, fragment);
                route = matched[1];
            }

            return {
                route : route,
                fragment : fragment,
                params : params
            };
        },

        defaultAction: function() {
            this.loadModule("modules/home/main");
            // console.log(this.current());
            // var hash = this.current();
        }
    });

    return new Router();

});


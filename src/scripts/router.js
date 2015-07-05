/*jslint regexp: true, nomen: true, sloppy: true */
/*global requirejs, require, define */


define(["underscore", "backbone"], function (_, Backbone) {

    'use strict';

     // Router
    var Router = Backbone.Router.extend({
        
        routes: {
            // "sample": "sample",
            // "licai": "licai",
            // "licai/:id": "licaiDetail"
            "*actions": "defaultAction"
        },

        
        loadModule: function (module, override) {
            require([override? module: "modules/" + module], function (module) {
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
            var current = this.current(),
                path = current.params[0],
                query = current.params[1],
                reg_path = /(\w+)\/(.*)/,
                fallback = "home/main",
                module, subpath;
            // console.log("router load "+path);

            if (!path || path == "/" || path == "" || path == "#") {
                // console.log("default; should return to index");
                this.loadModule(fallback);
                return;
            }
            
            if (reg_path.test(path)) {
                var m = path.match(reg_path);
                module = m[1];
                subpath = m[2];
            } else {
                module = path;
            }
            
            try {
                require(["modules/" + module + "/main"], function (module) {
                    if(_.isFunction(module)){
                        module(subpath, query);
                    }
                    else if(_.isObject(module)) {
                        module.initialize(subpath, query);
                    } 
                    else {
                        console.log('module '+moudle+' must be a Function or Object');
                    }
                });
            } catch(e) {
                this.loadModule(fallback);
                console.log( 'moudle ' + module + 'is not exist' );
            }

        }

    });

    return new Router();

});


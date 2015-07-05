/*jslint regexp: true, nomen: true, sloppy: true */
/*global requirejs, require */

(function () {

    'use strict';

    requirejs.config({
        baseUrl: "scripts/",
        paths: {
            "zepto": "libs/zepto",
            "underscore": "libs/underscore",
            "backbone": "libs/backbone",
            "text": "libs/text"
        },
        map: {
            "*": {
                "jquery": "zepto"
            }
        },
        shim: {
            zepto: {
                exports: 'Zepto'
            }
        }
    });
    

    require(['app'], function (app) {
        app.initialize();
    });

}());

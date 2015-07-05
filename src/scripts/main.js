/*jslint regexp: true, nomen: true, sloppy: true */
/*global requirejs, require */

(function () {

    'use strict';

    requirejs.config({
        baseUrl: "scripts/",
        paths: {
            "zepto": "libs/zepto",
            "underscore": "libs/underscore",
            "dust": "libs/dust-full",
            "backbone": "libs/backbone",
            "text": "libs/text",
            "common": "component/common"
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
    
    define.amd.dust = true;
    require(['app'], function (app) {
        app.initialize();
    });

}());

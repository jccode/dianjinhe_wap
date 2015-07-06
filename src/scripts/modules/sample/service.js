define(['jquery', 'underscore', 'text!./data/projects.json'], function($, _, data) {

    var getProjects = function() {
        return JSON.parse(data);
    };
    
    return {
        getProjects: getProjects
    };
});


define(['jquery', 'underscore', 'common', './service'], function($, _, c, service) {

    var projects = service.getProjects();
    
    var view = function(id) {
        console.log("view project: "+id);
        var item = _.filter(projects, function(project) {
            return project.id == id;
        });

        console.log( item );

        c.render("root", 'views/sample/detail', {'project':item});
    };

    var list = function(queryString) {
        console.log(projects);
        var data = {"projects": projects};
        c.render("root", 'views/sample/list', data);
    };
    
    return {
        initialize: function(subPath, queryString) {
            console.log( "subpath:" + subPath + " ; querystring:" +queryString );
            if(subPath) {
                view(subPath);
            } else {
                list(queryString);
            }
        }
    };
});

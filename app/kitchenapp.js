define([
  // Libs
  "jquery",
  "use!underscore",
  "use!backbone",
  "use!handlebars",
  "modelbinding",

  // Plugins
  "use!plugins/backbone.layoutmanager"
],

function($, _, Backbone, Handlebars, ModelBinding) {
  // Put application wide code here
  ModelBinding.Configuration.configureAllBindingAttributes("data-attr");
  Backbone.LayoutManager.configure({
    paths: {
      layout: "/app/templates/layouts/",
      template: "/app/templates/"
    },

    render: function(template, context) {
      return template(context);
    },

    fetch: function(path) {
      path = path + ".html";

      var done = this.async();
      var JST = window.JST = window.JST || {};

      if (JST[path]) {
        return done(Handlebars.template(JST[path]));
      }

      $.get(path, function(contents) {
        var tmpl = Handlebars.compile(contents);

        done(JST[path] = tmpl);
      }, "text");
    }
  });

  return {
    // Create a custom object with a nested Views object
    module: function(additionalProps) {
      return _.extend({ Views: {} }, additionalProps);
    },

    // Keep active application instances namespaced under an app object.
    app: _.extend({}, Backbone.Events)
  };
});

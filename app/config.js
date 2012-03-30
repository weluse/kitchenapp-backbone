// Set the require.js configuration for your application.
require.config({
  // Initialize the application with the main application file
  deps: ["main"],

  paths: {
    // JavaScript folders
    libs: "../assets/js/libs",
    plugins: "../assets/js/plugins",

    // Libraries
    jquery: "../assets/js/libs/jquery",
    underscore: "../assets/js/libs/underscore",
    backbone: "../assets/js/libs/backbone",
    synapse: "../assets/js/libs/synapse-0.5",
    handlebars: "../assets/js/libs/handlebars-1.0.0.beta.6",

    // Synapse hooks
    'synapse/jquery': "../assets/js/libs/synapse/jquery",
    'synapse/object': "../assets/js/libs/synapse/object",
    'synapse/backbone-model': "../assets/js/libs/synapse/backbone-model",
    'synapse/backbone-view': "../assets/js/libs/synapse/backbone-view",

    // Shim Plugin
    use: "../assets/js/plugins/use"
  },

  use: {
    backbone: {
      deps: ["use!underscore", "jquery"],
      attach: "Backbone"
    },

    underscore: {
      attach: "_"
    },

    handlebars: {
      attach: "Handlebars"
    },

    "plugins/backbone.layoutmanager": {
      deps: ["use!backbone"]
    }
  }
});

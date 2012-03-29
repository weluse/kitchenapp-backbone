require([
  "kitchenapp",

  // Libs
  "jquery",
  "use!backbone",

  // Modules
  "modules/person",
  "modules/task"
],

function(kitchenapp, $, Backbone, Person, Task) {

  // Shorthand the application namespace
  var app = kitchenapp.app;

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      "": "index",
      "show/:id": "show"
    },

    _initMain: function() {
      var main = new Backbone.LayoutManager({
        template: "main"
      });

      if (app.tasks === undefined) {
        app.tasks = new Task.Collection();
        app.tasks.loaded = app.tasks.fetch();

      }
      main.view("#kl-task-list", new Task.Views.List({
        collection: app.tasks
      }));

      return main;
    },

    index: function () {
      var main = this._initMain();

      main.render(function(el) {
        $("body").html(el);
      });
    },

    show: function(id) {
      var main = this._initMain();

      app.tasks.loaded.then(function () {
        detail = main.view("#kl-task-detail", new Task.Views.Detail());

        detail.model = app.tasks.get(id);
        detail.render();
      });

      main.render(function(el) {
        $("body").html(el);
      });
    }
  });

  // Treat the jQuery ready function as the entry point to the application.
  // Inside this function, kick-off all initialization, everything up to this
  // point should be definitions.
  $(function() {
    // Define your master router on the application namespace and trigger all
    // navigation from this instance.
    app.router = new Router();

    // Trigger the initial route and enable HTML5 History API support
    Backbone.history.start({ pushState: true });
  });

  // All navigation that is relative should be passed through the navigate
  // method, to be processed by the router.  If the link has a data-bypass
  // attribute, bypass the delegation completely.
  $(document).on("click", "a:not([data-bypass])", function(evt) {
    // Get the anchor href and protcol
    var href = $(this).attr("href");
    var protocol = this.protocol + "//";

    // Ensure the protocol is not part of URL, meaning its relative.
    if (href && href.slice(0, protocol.length) !== protocol) {
      // Stop the default event to ensure the link will not cause a page
      // refresh.
      evt.preventDefault();

      // `Backbone.history.navigate` is sufficient for all Routers and will
      // trigger the correct events.  The Router's internal `navigate` method
      // calls this anyways.
      Backbone.history.navigate(href, true);
    }
  });

});

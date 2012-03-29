define [
  "kitchenapp",
  "use!backbone",
  "modelbinding"
], (kitchenapp, Backbone) ->
  Backbone.ModelBinding = require('modelbinding')
  # XXX: DEBUG!!
  window.Task = Task = kitchenapp.module()
  app = kitchenapp.app

  class Task.Model extends Backbone.Model

  class Task.Collection extends Backbone.Collection
    url: "https://kitchenlist.herokuapp.com/v1/task"
    model: Task.Model

  class Task.Views.List extends Backbone.LayoutManager.View
    template: "task/list"

    initialize: ->
      @collection.bind('reset', => @render())
      @collection.bind('change', => @render())

    render: (layout) ->
      view = layout(this)
      @collection.each((element) ->
        view.insert("ul", new Task.Views.Element({model: element}))
      )

      return view.render(@collection)

  class Task.Views.Element extends Backbone.LayoutManager.View
    template: "task/element"
    tagName: "li"
    events:
      click: 'loadDetail'

    serialize: ->
      return @model.toJSON()

    loadDetail: ->
      app.router.navigate("/show/#{@model.id}", {trigger: true})

  class Task.Views.Detail extends Backbone.LayoutManager.View
    template: "task/detail"
    events:
      "click button": 'save'

    serialize: ->
      return @model.toJSON()

    render: (layout) ->
      r = layout(this).render()

      return r.then(=>
        console.log("Bound to ", this.model.get("id"))
        Backbone.ModelBinding.bind(this)
      )

    save: (ev) ->
      console.log("Saving task data")
      @model.save()

  return Task

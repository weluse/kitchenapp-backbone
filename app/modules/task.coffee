define [
    "kitchenapp",
    "use!backbone"
], (kitchenapp, Backbone) ->
  # XXX: DEBUG!!
  window.Task = Task = kitchenapp.module()

  class Task.Model extends Backbone.Model

  class Task.Collection extends Backbone.Collection
    url: "https://kitchenlist.herokuapp.com/v1/task"
    model: Task.Model

  class Task.Views.List extends Backbone.LayoutManager.View
    template: "task/list"

    initialize: ->
      @collection.bind('reset', => @render())

    render: (layout) ->
      view = layout(this)
      @collection.each((element) ->
        view.insert("ul", new Task.Views.Element({model: element}))
      )

      return view.render(@collection)

  class Task.Views.Element extends Backbone.LayoutManager.View
    template: "task/element"
    tagName: "li"

    serialize: ->
      return @model.toJSON()

  return Task

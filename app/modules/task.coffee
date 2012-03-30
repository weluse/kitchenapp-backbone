define [
  "kitchenapp",
  "use!backbone",
  "synapse"
], (kitchenapp, Backbone, Synapse) ->
  Task = kitchenapp.module()
  app = kitchenapp.app

  class Task.Model extends Backbone.Model

  class Task.Collection extends Backbone.Collection
    url: "https://kitchenlist.herokuapp.com/v1/task"
    model: Task.Model

  class Task.Views.List extends Backbone.LayoutManager.View
    template: "task/list"

    initialize: ->
      # Ineffecient!
      @collection.on('reset change', => @render())

    render: (layout) ->
      view = layout(this)

      view.cleanup()

      @collection.each((element) ->
        view.insert("ul", new Task.Views.Element({model: element}), true)
      )

      return view.render()

  class Task.Views.Element extends Backbone.LayoutManager.View
    template: "task/element"
    tagName: "li"
    events:
      "click .text": 'loadDetail'

    initialize: ->
      @model.on('change:done', @model.save, @model)

    serialize: ->
      return @model.toJSON()

    loadDetail: (ev) ->
      ev.preventDefault()

      @cleanup()
      app.router.navigate("/show/#{@model.id}", {trigger: true})

    render: (layout) ->
      layout(this).render().then(=>
      )

    cleanup: ->
      @model.off('change:done')

  class Task.Views.Detail extends Backbone.LayoutManager.View
    template: "task/detail"
    events:
      "click button": 'save'
      "click .delete": 'delete'

    serialize: ->
      return @model.toJSON()

    render: (layout) ->
      window.cm = @model
      return layout(this).render().then(=>
        console.log("Bound to ", @model.get("id"))

        data = Synapse(@model)
        field = Synapse(@$('[data-bind=title]'))
        data.syncWith(field)
      )

    save: (ev) ->
      ev.preventDefault()
      console.log("Saving task data")
      @model.save()

    delete: (ev) ->
      ev.preventDefault()

      if confirm("Really?")
        @model.destroy()
        app.router.navigate("/", {trigger: true})

    cleanup: ->


  class Task.Views.Create extends Backbone.LayoutManager.View
    template: "task/create"
    events:
      "click button": 'save'
      "keypress input": 'onInputKeydown'

    initialize: ->
      console.log("Initializing with new task")
      # Initialize with empty model
      @model = new Backbone.Model()

    render: (layout) ->
      layout(this).render().then(=>
      )

    onInputKeydown: (ev) ->
      # Enter
      if ev.keyCode == 13
        ev.preventDefault()
        ev.stopPropagation()
        # Enforce change event
        @$(ev.target).change()
        @save()

    save: (ev) ->
      ev?.preventDefault()

      console.log("Creating new task ...")
      @collection.create(@model.toJSON())
      # Start over
      @initialize()
      @render()

  return Task

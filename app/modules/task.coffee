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

  return Task

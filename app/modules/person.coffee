define [
    "kitchenapp",
    "use!backbone"
], (kitchenapp, Backbone) ->
  # XXX: DEBUG!!
  window.Person = Person = kitchenapp.module()

  class Person.Model extends Backbone.Model

  class Person.Collection extends Backbone.Collection
    url: "https://kitchenlist.herokuapp.com/v1/person"
    model: Person.Model

  return Person

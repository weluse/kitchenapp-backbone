###
# Backbone Datalink Library v0.1
#
# Simple wrapper around Synapse to work as easy as possible with your
# Backbone models and views.
#
# Copyright 2012, Pascal Hartig
# Dual licensed under the MIT or GPL Version 3 licenses.
###

((root, factory) ->
    if typeof exports isnt 'undefined'
        # Node/CommonJS
        factory(root, exports, require('synapse'))
    else if typeof define is 'function' and define.amd
        # AMD
        define('datalink', ['synapse', 'exports'], (core, exports) ->
            factory(root, exports, core))
    else
        # Browser globals
        root.ObjectHook = factory(root, {}, root.Synapse)
)(this, (root, ObjectHook, Synapse) ->
    checkView = (view) ->
        unless view.model?
            throw new Error "View #{view.toString()} must be bound to a model!"

    return {
        defaultOptions:
            # Binding function. One of syncWith, observe, notify.
            bind: 'syncWith'
            # Attribute to look for to map elements
            attribute: 'data-bind'

        linkView: (view, elements, defaultOptions, elementOptions) ->
            # Build local default options
            defaults = _.defaults(defaultOptions or {}, @defaultOptions)

            checkView(view)
            observer = Synapse(view.model)
            observeFn = observer[defaults.bind]

            bind = ($element, localElementOptions) ->
                if (customBind = localElementOptions?.bind)
                    localObserveFn = observer[customBind]
                else
                    localObserveFn = observeFn

                localObserveFn.call(observer, $element)

            findElement = (element, localElementOptions) ->
                attribute = localElementOptions?.attribute or defaults.attribute
                $element = view.$("[#{attribute}=#{element}")

            for element in elements
                localElementOptions = elementOptions[element]
                # Build jQuery object
                $element = findElement(element, localElementOptions)
                bind($element, localElementOptions)
    }
)

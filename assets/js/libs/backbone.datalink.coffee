###
# Backbone Datalink Library v0.1
#
# Simple wrapper around Synapse to work as easy as possible with your
# Backbone models and views.
#
# Copyright 2012, Pascal Hartig
# Dual licensed under the MIT or GPL Version 3 lincenses.
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
)(this, (root, ObjectHook, core) ->
    # Code here.
)

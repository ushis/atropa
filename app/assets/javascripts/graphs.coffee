# graphs.coffee
#
# Concatenates all graph scripts and the d3 lib.
#
# requires       jQuery >= 1.7
#
# =require       d3
# =require_tree  ./graphs

String::capitalize = ->
  if @.length is 0 then '' else @[0].toUpperCase() + @[1..]

do ($ = jQuery) ->
  $.fn.atropaGraph = (graph, uri, options) ->
    @each ->
      fn = $(@)["atropa#{graph.capitalize()}"]

      if fn?
        fn.call $(@), uri, options
      else
        console.log "Graph not found: #{graph}"

# tagmap.coffee
#
# requires  jQuery >= 1.7
# requires  D3     >= 2

do ($ = jQuery) ->
  $.fn.atropaTagmap = (uri, options) ->
    settings = $.extend {
      width: 640,
      height: 400,
      sticky: true,
      duration: 400
    }, options

    cell = () ->
      @style('left', (d) -> "#{d.x}px")
      @style('top', (d) -> "#{d.y}px")
      @style('width', (d) -> "#{Math.max(0, d.dx - 1)}px")
      @style('height', (d) -> "#{Math.max(0, d.dy - 1)}px")

    @each ->
      el = d3.select('#' + $(@).attr('id'))
             .style('position', 'relative')
             .style('width', "#{settings.width}px")
             .style('height', "#{settings.height}px")

      treemap = d3.layout.treemap()
                  .size([settings.width, settings.height])
                  .value((d) -> d.usage)
                  .sort((x, y) -> x.tag < y.tag)

      d3.json uri, (json) ->
        el.data([children: json])
          .selectAll('div')
          .data(treemap.nodes)
          .enter()
          .append('div')
          .attr('class', (d) -> 'empty' unless d.children)
          .html((d) -> "<p>#{d.tag}</p>" unless d.children)
          .attr('title', (d) -> "#{d.usage} videos" unless d.children)
          .on('click', (d) -> window.location = "/tag/#{d.id}/#{d.slug}")
          .transition()
          .duration(settings.duration)
          .call(cell)

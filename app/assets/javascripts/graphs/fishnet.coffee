# stats.coffee
#
# requires  jQuery >= 1.7
# requires  D3     >= 2

do ($ = jQuery) ->
  $.fn.atropaFishnet = (uri, options) ->
    settings = $.extend {
      width: 640,
      height: 800,
      r: 10,
      linkDistance: 120,
      friction: 0.4,
      gravity: .14
      charge: -500,
    }, options

    @each ->
      el = d3.select '#' + $(@).attr('id')

      force = d3.layout
                .force()
                .charge(settings.charge)
                .gravity(settings.gravity)
                .friction(settings.friction)
                .linkDistance(settings.linkDistance)
                .size([settings.width, settings.height])

      svg = el.append('svg')
              .attr('width', settings.width)
              .attr('height', settings.height)

      d3.json uri, (json) ->
        json.videos.byId = (id) ->
          for video in @
            if video.id is id
              return video

        for link in json.links
          link.source = json.videos.byId(link.x)
          link.target = json.videos.byId(link.y)

        force.nodes(json.videos)
             .links(json.links)
             .start()

        links = svg.selectAll('line.link')
                   .data(json.links)
                   .enter()
                   .append('line')

        nodes = svg.selectAll('circle.node')
                   .data(json.videos)
                   .enter()
                   .append('circle')
                   .attr('r', settings.r)
                   .call(force.drag)

        nodes.append('title').text (d) -> d.title

        nodes.on 'mouseover', (d) ->
          links.classed('highlight', (_d) -> _d.source is d || _d.target is d)

        nodes.on 'mouseout', (d) -> links.classed 'highlight', false
        nodes.on 'dblclick', (d) -> window.location = d.url

        force.on 'tick', () ->
          offset = settings.r * 2

          nodes.attr('cx', (d) -> d.x = Math.max(offset, Math.min(settings.width - offset, d.x)))
               .attr('cy', (d) -> d.y = Math.max(offset, Math.min(settings.height - offset, d.y)))

          links.attr('x1', (d) -> d.source.x)
               .attr('y1', (d) -> d.source.y)
               .attr('x2', (d) -> d.target.x)
               .attr('y2', (d) -> d.target.y)

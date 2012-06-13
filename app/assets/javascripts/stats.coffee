# stats.coffee
#
# requires  jQuery >= 1.7
# requires  D3     >= 2

do ($ = jQuery) ->
  $.fn.atropaConnections = (uri, options) ->
    settings = $.extend {
      width: 640,
      height: 400,
      r: 10,
      linkDistance: 120,
      friction: 0.4,
      gravity: .14
      charge: -500,
      color: '#333'
      colorHightlight: '#ff7916'
      stroke: '#222'
      strokeHighlight: '#333',
      duration: 400
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
                   .style('stroke', settings.stroke)

        nodes = svg.selectAll('circle.node')
                   .data(json.videos)
                   .enter()
                   .append('circle')
                   .attr('r', settings.r)
                   .style('fill', settings.color)
                   .style('cursor', 'move')
                   .call(force.drag)

        nodes.append('title').text (d) -> d.title

        nodes.on 'mouseover', (d) ->
          d3.select(@)
            .transition()
            .duration(settings.duration)
            .style('fill', settings.colorHightlight)

          links.filter((ld) -> ld.source is d || ld.target is d)
               .transition()
               .duration(settings.duration)
               .style('stroke', settings.strokeHighlight)

        nodes.on 'mouseout', () ->
          d3.select(@)
            .transition()
            .duration(settings.duration)
            .style('fill', settings.color)

          links.transition()
               .duration(settings.duration)
               .style('stroke', settings.stroke)

        nodes.on 'dblclick', (d) ->
          window.location = d.url

        force.on 'tick', () ->
          links.attr('x1', (d) -> d.source.x)
               .attr('y1', (d) -> d.source.y)
               .attr('x2', (d) -> d.target.x)
               .attr('y2', (d) -> d.target.y)

          nodes.attr('cx', (d) -> d.x)
               .attr('cy', (d) -> d.y)

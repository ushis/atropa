# fountain.coffee
#
# requires  jQuery >= 1.7
# requires  D3     >= 2

do ($ = jQuery) ->
  $.fn.atropaFountain = (uri, options) ->
    settings = $.extend {
      width: 640,
      height: 640,
      padding: .02
    }, options

    settings.outerRadius = Math.min(settings.width, settings.height) / 2 - 70
    settings.innerRadius = settings.outerRadius - 24

    nullMatrix = (len) -> ((0 for i in [0...len]) for j in [0...len])

    @each ->
      el = $(@)

      arc = d3.svg.arc()
              .outerRadius(settings.outerRadius)
              .innerRadius(settings.innerRadius)

      layout = d3.layout.chord()
                 .padding(settings.padding)
                 .sortSubgroups(d3.descending)
                 .sortChords(d3.ascending)

      path = d3.svg.chord()
               .radius(settings.innerRadius)

      svg = d3.select("\##{el.attr('id')}")
              .append('svg')
              .attr('width', settings.width)
              .attr('height', settings.height)
              .append('g')
              .attr('transform', "translate(#{settings.width / 2}, #{settings.height / 2})")

      d3.json uri, (json) ->
        json.videos.indexById = (id) ->
          for video, i in @
            if video.id is id
              return i

        matrix = nullMatrix json.videos.length

        for link in json.links
          i = json.videos.indexById(link.x)
          j = json.videos.indexById(link.y)
          matrix[i][j] = ++matrix[j][i]

        layout.matrix(matrix)

        group = svg.selectAll('g.group')
                   .data(layout.groups)
                   .enter()
                   .append('g')

        group.append('title').text((d, i) -> json.videos[i].title)

        group.append('text')
             .text((d, i) -> json.videos[i].title[0..8] if d.value > 0)
             .attr 'transform', (d) ->
               "rotate(#{(d.startAngle + d.endAngle) * 90 / Math.PI - 89})" +
               "translate(#{settings.outerRadius + 4}, 0)"

        group.append('path')
             .attr('d', arc)
             .attr('class', 'node')

        chord = svg.selectAll('path.chord')
                   .data(layout.chords)
                   .enter()
                   .append('path')
                   .attr('d', path)
                   .attr('class', 'chord')

        group.on 'mouseover', (d, i) ->
          targets = [i]

          el.addClass('active')

          chord.classed 'highlight', (p) ->
            if p.source.index == i
              targets.push p.target.index
            else if p.target.index == i
              targets.push p.source.index
            else
              return false

          group.classed 'highlight', (_d, _i) -> $.inArray(_i, targets) > -1

        el.mouseleave ->
          $(@).removeClass('active')
          chord.classed 'highlight', false
          group.classed 'highlight', false

        group.on 'dblclick', (d, i) -> window.location = json.videos[i].url

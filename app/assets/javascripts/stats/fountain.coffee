# fountain.coffee
#
# requires  jQuery >= 1.7
# requires  D3     >= 2

do ($ = jQuery) ->
  $.fn.atropaFountain = (uri, options) ->
    settings = $.extend {
      width: 640,
      height: 400,
      padding: .02,
      color: '#2f2f2f',
      color2: '#222',
      highlight: '#ff7916',
      background: '#111'
    }, options

    settings.outerRadius = Math.min(settings.width, settings.height) / 2
    settings.innerRadius = settings.outerRadius - 24

    nullMatrix = (len) ->
      ((0 for i in [0...len]) for j in [0...len])

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
              .attr('class', 'main')
              .attr('transform', "translate(#{settings.width / 2}, #{settings.height / 2})")
              .style('fill', settings.background)

      svg.append('circle').attr('r', settings.outerRadius)

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

        groupPath = group.append('path')
                         .attr('d', arc)
                         .style('fill', settings.color2)

        chord = svg.selectAll('path.chord')
                   .data(layout.chords)
                   .enter()
                   .append('path')
                   .style('fill', settings.color)
                   .attr('d', path)

        group.on 'mouseover', (d, i) ->
          targets = [i]

          chord.style('fill', settings.highlight)
               .classed('fade', (p) -> p.source.index != i && p.target.index != i)
               .each (p) ->
                 if p.source.index == i
                   targets.push p.target.index
                 else if p.target.index == i
                   targets.push p.source.index

          groupPath.style 'fill', (_d, _i) ->
            if $.inArray(_i, targets) > -1 then settings.highlight else settings.color2

        el.mouseleave ->
          chord.style('fill', settings.color).classed 'fade', false
          groupPath.style('fill', settings.color2).classed 'fade', false

        group.on 'dblclick', (d, i) ->
          window.location = json.videos[i].url

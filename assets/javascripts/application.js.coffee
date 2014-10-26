angular.module 'myApp', ['myApp.controllers', 'myApp.directives']

angular.module('myApp.directives', [])
  .directive 'wheel', ->
    restrict: 'E'
    scope:
      flare: '=flare'
    link: (scope, element, attrs) ->
      div = d3.select('#vis')
      scope.render = (flare) ->
        width = 960
        height = 700
        radius = Math.min(width, height) / 2
        x = d3.scale.linear().range([
          0
          2 * Math.PI
        ])
        y = d3.scale.linear().range([
          0
          radius
        ])

        div.selectAll('*').remove()

        color = d3.scale.category20c()
        wheel = div.append('svg').attr('width', width).attr('height', height).append('g').attr('transform', 'translate(' + width / 2 + ',' + (height / 2 + 10) + ')')

        partition = d3.layout.partition().value((d) ->
         d.size
        )
        arc = d3.svg.arc().startAngle((d) ->
          Math.max 0, Math.min(2 * Math.PI, x(d.x))
        ).endAngle((d) ->
          Math.max 0, Math.min(2 * Math.PI, x(d.x + d.dx))
        ).innerRadius((d) ->
          Math.max 0, y(d.y)
        ).outerRadius((d) ->
          Math.max 0, y(d.y + d.dy)
        )
      
        computeTextRotation = (d) ->
          (x(d.x + d.dx / 2) - Math.PI / 2) / Math.PI * 180

        click = (d) ->
          # fade out all text elements
          text.transition().attr 'opacity', 0
          path.transition().duration(750).attrTween('d', arcTween(d)).each 'end', (e, i) ->
            # check if the animated element's data e lies within the visible angle span given in d
            if e.x >= d.x and e.x < (d.x + d.dx)

             # get a selection of the associated text element
             arcText = d3.select(@parentNode).select('text')

             # fade in the text element and recalculate positions
             arcText.transition().duration(750).attr('opacity', 1).attr('transform', ->
               'rotate(' + computeTextRotation(e) + ')'
             ).attr 'x', (d) ->
               y d.y

              
        g = wheel.selectAll('g').data(partition.nodes(flare)).enter().append('g')
        path = g.append('path').attr('d', arc).style('fill', (d) ->
         color ((if d.children then d else d.parent)).name).on('click', click)
        text = g.append('text').attr('transform', (d) ->
         'rotate(' + computeTextRotation(d) + ')'
        ).attr('x', (d) ->
         y d.y
        ).attr('dx', '6').attr('dy', '.35em').text((d) ->
         d.name
        )

        # Interpolate the scales!
        arcTween = (d) ->
         xd = d3.interpolate(x.domain(), [
           d.x
           d.x + d.dx
          ])
              
         yd = d3.interpolate(y.domain(), [
           d.y
           1
         ])

         yr = d3.interpolate(y.range(), [
           (if d.y then 20 else 0)
           radius
         ])
         (d, i) ->
           (if i then (t) ->
             arc d
            else (t) ->
             x.domain xd(t)
             y.domain(yd(t)).range yr(t)
             arc d
           )
        
   
      scope.$watch 'flare', (value) -> #I change here
        flare = value or null
        scope.render(flare) if flare
      
      
angular.module('myApp.controllers', [])
  .controller 'listCtrl' , ($scope) ->
    
    clusters = [{'id':0,'size':6,'phrases':["Tomato"],"score":13.9740806226073,"documents":["4","6","16","21","28","36"],"attributes":{"score":13.9740806226073}},{"id":1,"size":4,"phrases":["Pesto"],"score":16.141320903024564,"documents":["19","30","32","33"],"attributes":{"score":16.141320903024564}},{"id":2,"size":4,"phrases":["Vinaigrette"],"score":13.415007350276419,"documents":["34","37","38","39"],"attributes":{"score":13.415007350276419}},{"id":3,"size":3,"phrases":["Fresh"],"score":12.87608828899308,"documents":["28","32","39"],"attributes":{"score":12.87608828899308}},{"id":4,"size":3,"phrases":["Grilled"],"score":10.215826667473063,"documents":["15","24","28"],"attributes":{"score":10.215826667473063}},{"id":5,"size":3,"phrases":["Mediterranean"],"score":11.621345956677192,"documents":["15","35","36"],"attributes":{"score":11.621345956677192}},{"id":6,"size":3,"phrases":["Olive"],"score":7.331734539641137,"documents":["2","3","16"],"attributes":{"score":7.331734539641137}},{"id":7,"size":3,"phrases":["Shrimp"],"score":15.2984355428096,"documents":["13","14","34"],"attributes":{"score":15.2984355428096}},{"id":8,"size":3,"phrases":["Tart"],"score":16.594156994506875,"documents":["9","10","11"],"attributes":{"score":16.594156994506875}},{"id":9,"size":2,"phrases":["Fennel"],"score":11.770685448051502,"documents":["31","37"],"attributes":{"score":11.770685448051502}},{"id":10,"size":2,"phrases":["Hummus"],"score":11.23907111864989,"documents":["0","1"],"attributes":{"score":11.23907111864989}},{"id":11,"size":2,"phrases":["Pizza"],"score":9.189378326267782,"documents":["19","24"],"attributes":{"score":9.189378326267782}},{"id":12,"size":2,"phrases":["Prosciutto"],"score":10.638550633004753,"documents":["5","6"],"attributes":{"score":10.638550633004753}},{"id":13,"size":2,"phrases":["Red Pepper"],"score":16.508001555020474,"documents":["0","3"],"attributes":{"score":16.508001555020474}},{"id":14,"size":2,"phrases":["Sauce"],"score":11.754045018466776,"documents":["21","29"],"attributes":{"score":11.754045018466776}},{"id":15,"size":2,"phrases":["Tom's Tortellini with Garlic Basil"],"score":16.636598474202014,"documents":["23","25"],"attributes":{"score":16.636598474202014}},{"id":16,"size":2,"phrases":["Tomato Basil"],"score":1.4880449545071657,"documents":["4","28"],"attributes":{"score":1.4880449545071657}},{"id":17,"size":2,"phrases":["Yogurt"],"score":9.739997440423227,"documents":["17","26"],"attributes":{"score":9.739997440423227}},{"id":18,"size":7,"phrases":["Other Topics"],"score":0.0,"documents":["7","8","12","18","20","22","27"],"attributes":{"other-topics":true,"score":0.0}}]


    $scope.phrases = _.map clusters, (c) ->
      "#{c.phrases[0]} #{c.documents}"


    #$scope.flare = eval(get_flare clusters)
    $scope.flare = get_flare clusters
    

get_children = (index, index2, clusters, documents) ->unless index == (clusters.length - 1)    # If not last cluster
  orphans = {'name': ''}
  intr    = _.intersection(documents, clusters[index2].documents);    

  if intr.length > 0    # continue drilling
    if index2 < (clusters.length - 1)    # Up until last element.
       # Get next layer of orphans
      orphan_docs = _.difference(intr, clusters[index2 + 1].documents)
      if orphan_docs.length > 0
        orphans = {'name': orphan_docs, 'size': orphan_docs.length}

      if _.intersection(intr, clusters[index2 + 1].documents).length > 0
        return [orphans, {'name': clusters[index2+1].phrases[0], 'children': get_children(index, (index2 + 1), clusters, intr)}]
      else 
        return [orphans]
    else
      # At second to last cluster, so terminate here
      return [{'name': inter}]  
  else                                # No intersection, so return bundle of current documents.
    return [{'name': documents}]  

  return [{'name': _.intersection(clusters[index].documents, clusters[index2].documents)}]


get_flare = (clusters) ->
  # Make root object
  flare =
    name: 'root'
    children: []

  children = flare.children
  _.each(clusters[0..(clusters.length - 2)], (cluster, index) ->   # All clusters but the last. (It has already been compared to previous ones)
    #All documents for all remaining clusters in array
    remaining_documents =  _.flatten(_.map clusters[(index + 1)..clusters.length], (c) ->
      c.documents
    )

    root_child = {'name':  cluster.phrases[0], 'children': []}

    # Get first layer of orphans
    orphan_docs = _.difference(cluster.documents, remaining_documents)

    if orphan_docs.length > 0
      root_child.children.push {'name': orphan_docs, size: orphan_docs.length}

    for index2 in [(index + 1)..(clusters.length - 1)] by 1
      if _.intersection(cluster.documents, clusters[index2].documents).length > 0
        root_child.children.push {'name': clusters[index2].phrases[0], 'children': get_children(index, (index2), clusters, cluster.documents)}

    children.push root_child
  )  
  flare

var margin = {top: 20, right: 60, bottom: 20, left: 60},
    width = 960 - margin.right - margin.left,
    height = 800 - margin.top - margin.bottom;

var i = 0,
    duration = 750,
    root;

var tree = d3.layout.tree()
    .size([width, height]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) {
      var cordX = d.x + 55, cordY = d.y+40;
       return [cordX, cordY]; 
    }); 
var  svg = d3.select(".container").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var employee = {
  post: "Генальный Директор",
  children:[
    {
      assistent:'1 помощник'
    },
    { 
      assistent:'1 помощник'
    },
    {
        post:"ДиректорIT",
        children:[{post:'МенеджерИТ'},{post:"Главный прогер"}],
    },
    {
        post:"Директор по персоналу",
        children:[{post:'HR1'},{post:"HR2"}]
    }
    ]
}

  root = employee;
  root.x0 = 0;
  root.y0 = 0;


  function collapse(d) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach(collapse);
      d.children = null;
    }
  };
  root.children.forEach(collapse);
  update(root);

d3.select(self.frameElement).style("width", "960px");

function update(source) {
  // Compute the new tree layout.
  var nodes = tree.nodes(root),
      links = tree.links(nodes);

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { 
    d.assistent ? d.y = d.depth * 50:d.y = d.depth * 100;
   });


  // Update the nodes…
  var node = svg.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.x0 + "," + source.y + ")"; })
      .on("click", click)

  nodeEnter.append("rect")
      .attr("class", function(d){ return d.assistent ? "assistent" : "post" });
      
  nodeEnter.append("text").append('tspan')
      .attr("x", "5")
      .attr("dy", "2.2em")
      .attr("text-anchor", "start")
      .text(function(d) { return d.post || d.assistent; })
      .attr("class", function(d){ return d.assistent ? "assistent" : "post" })
      .style("fill-opacity", 1);

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

  
  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.x + "," + source.y + ")"; })
      .remove();

  
  // Update the links…
  var link = svg.selectAll("path.link")
      .data(links, function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      });

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null; 
  }
  update(d);
}

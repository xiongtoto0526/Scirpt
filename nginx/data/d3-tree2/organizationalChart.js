/*---------------------------------------------------
*	Javascript construction of an organization chart
*	from a JSON definition with hierarchical relations
*	using the d3.js library 
*
*	Made by Florian Perrotti
-----------------------------------------------------*/

// Definition of the chart to build

var orgChart = {
  "stc_company": "STOIC",
  "stc_employees": [
    {
      "stc_name": "Ismael Ghalimi",
      "stc_identifier": "ismael",
      "stc_picture": "http://www.gravatar.com/avatar/a33dab7034e1fced4adb648f46eabe5d?d=identicon&s=64",
      "stc_role": "Chief executive officer",
      "stc_parent": null
    },
    {
      "stc_name": "Jacques-Alexandre Gerber",
      "stc_identifier": "jag",
      "stc_picture": "http://www.gravatar.com/avatar/6a6e26e2ba226b66e9fa74d652fa37e8?d=identicon&s=64",
      "stc_role": "Chief financial officer",
      "stc_parent": "ismael"
    },
    {
      "stc_name": "Pascal Belloncle",
      "stc_identifier": "psq",
      "stc_picture": "http://www.gravatar.com/avatar/208b9d061b14c7e819ed2f03ba93780e?d=identicon&s=64",
      "stc_role": "Chief technology officer",
      "stc_parent": "ismael"
    },
    {
      "stc_name": "Hugues Malphettes",
      "stc_identifier": "hugues",
      "stc_picture": "http://www.gravatar.com/avatar/5f1f4b0d2440d947efb26778f01e9af6?d=identicon&s=64",
      "stc_role": "Back-end developer",
      "stc_parent": "psq"
    },
    {
      "stc_name": "Jim Alateras",
      "stc_identifier": "jim",
      "stc_picture": "http://www.gravatar.com/avatar/3d508d960d5f63a9d9384baf6b4f67c3?d=identicon&s=64",
      "stc_role": "Back-end developer",
      "stc_parent": "psq"
    },
    {
      "stc_name": "Florian Ribon",
      "stc_identifier": "floribon",
      "stc_picture": "http://www.gravatar.com/avatar/c8dea32e0d638bbf18f9d87318df326c?d=identicon&s=64",
      "stc_role": "Front-end developer",
      "stc_parent": "ismael"
    },
    {
      "stc_name": "Francois Beaufils",
      "stc_identifier": "francois",
      "stc_picture": "http://www.gravatar.com/avatar/ac21f579f4566e26d85988209080b031?d=identicon&s=64",
      "stc_role": "Front-end developer",
      "stc_parent": "ismael"
    }
  ]
};

// First thing to do is to add a title to the page

var title = d3.select("body")
		  	  .insert('h1','div')
		  	  .text("Organizational chart of : "+orgChart.stc_company)
			  .attr("class","title");
			  
var titlePage = d3.select("head")
		  	  .insert('title','style')
		  	  .text("Organizational chart of : "+orgChart.stc_company);


// Conversion of the employees list to match the required format of the d3 tree layout

var convertedChart = (convert(orgChart.stc_employees))[0];

// Initalisation of the global variables
	
	
	/* Fixed values : i = index, depth = distance between each node level,
	 * rectW = initial value the boxes' width, rectH = value the boxes' height,
	 * sizePic = size of picture (square), margin = constant of blank space,
	 * marginLeft = margin for the left side, nodeSize = parameter which
	 * tells d3 the wanted space between nodes
	 */
	 
var i = 0,
	depth = 140,
    rectW = 140,
    rectH = 65,
    sizePic = rectH-1,
    margin = 10,
    marginLeft = 120,
    nodeSize = [225,100];
    
// Creation of the d3 objects and creation of the organizational chart

var tree = d3.layout.tree().nodeSize(nodeSize);
var svg = d3.select("#chart").append("svg")
var svgG = svg.append("g");

// Creation and display of the organizational chart

var sizeGraph = createOrganizationalChart(convertedChart);

// Adjustment of the size of the <div class='chart'> according to the size of the graph

d3.select("#chart").style("height", sizeGraph[0]).style("width",sizeGraph[1]);    
    

// Functions declaration

	// function which converts an array such as orgChart above into an 
	// array with the required format of the d3 tree layout
	
function convert(array){
    var map = {};
    for(var i = 0; i < array.length; i++){
        var obj = array[i];
        obj.children= [];
        
        map[obj.stc_identifier] = obj;
        
        var parent = obj.stc_parent || '-';
        if(!map[parent]){
            map[parent] = {
                children: []
            };
        }
        map[parent].children.push(obj);
    }
    
    return map['-'].children;
    
}

	// function that creates the straight links between boxes
	
function elbow(d, i) {
  return "M" + d.source.x + "," + d.source.y
  	   + "V" + (d.source.y+depth/2)
       + "H" + d.target.x +"V" + d.target.y;
}
	
	// function that compares the size of stc_name and stc_role in a text element
	// for each node and returns the array containing the bigger one for each node
	
function getWidthArray(text1,text2) {
	var width1 = [],
		width2 = [],
		maxWidth= [];
		
	text1.each(function(d,i) {
    	width1[i]=this.getBBox().width;
    });
    text2.each(function(d,i) {
    	width2[i]=this.getBBox().width;
    });
    if(width1.length != width2.length) {
    	return -1;
    } else {
    	for(var i = 0; i < width1.length ; i++) {
    		maxWidth[i] = width1[i] > width2[i] ? width1[i] : width2[i];
    	} 
    }
    
    return maxWidth;
}

	// function that returns the max value in the array array

function maxValue(array) {
	var max = 0;
	for(var i = 0; i < array.length;i++) {
		if (array[i] > max) {
			max = array[i];
		}
	}
	if (typeof max!="number") {
		return -1;
	}
	
	return max;
	
}

function createOrganizationalChart(source) {

	// Delimiters of the graph's size
	
	var x_min = 0, x_max = 0, y_max = 0;

    // Compute the tree layout
    var nodes = tree.nodes(convertedChart),
        links = tree.links(nodes);

	
    // Normalize for fixed-depth using the global variable 'depth'
    nodes.forEach(function (d) {
        d.y = d.depth * depth;
    });


 	var link = svgG.selectAll("path.link")
        .data(links)
        .enter().append("path")
        .attr("class", "link")
        .attr("d", elbow);

    // Place the nodes to their location and compute the real size of the graph (width & height)
    
    var node = svgG.selectAll("g.node")
        .data(nodes).enter().append("g")
        .attr("class","node")
        .attr("transform",function (d,i) {
        	if(d.x < x_min) {
        		x_min = d.x;
        	} else if(d.x > x_max){
        		x_max = d.x;
        	}
        	if(d.y > y_max) {
        		y_max = d.y;
        	}
        	return "translate(" + (d.x-rectW/2) + "," + (d.y-sizePic/2-margin) + ")";});
        	
 	// place the corresponding image on each node
    var img = node.append("svg:image")
    	.attr("xlink:href",function (d) {return d.stc_picture;})
    	.attr("x",0)
    	.attr("y",0)
    	.attr('width', sizePic)
        .attr('height',sizePic);
        
    // place the corresponding name on each node
    var name = node.append("text")
        .attr("x", margin+rectH)
        .attr("y", 2*margin)
        .text(function (d) {
        return d.stc_name;
    });
  	// place the corresponding role on each node
    var role = node.append("text")
        .attr("x", margin+rectH)
        .attr("y", 4*margin)
        .text(function (d) {
        return d.stc_role;
    });
    
    // get the width of the longest text
    var widthArray = getWidthArray(name,role);
    
    // move the node to be aligned with the links
    node.attr("transform",function (d,i) {
    				return "translate(" + (d.x - (widthArray[i]+2*margin+rectH)/2) + "," + (d.y-rectH/2) + ")";})
    
    // insert the rectangle (box) before the image so that the texts and the image are above it
	var rect = node.insert("rect","image")
        .attr("width",function(d,i) {return widthArray[i]+2*margin+rectH;})
        .attr("height", rectH)
        .attr("stroke", "black")
        .attr("stroke-width", 1)
        .style("fill", "#fff");
   
   // Here I resize the svg element so that the graph fits in it
   
   widthUpdated = 2*maxValue([-x_min,x_max]) + maxValue(widthArray) + 2*margin + rectH + marginLeft;
   heightUpdated = y_max + 2*rectH ;
   
   svg.attr("width",widthUpdated)
      .attr("height",heightUpdated);
   svgG.attr("transform", "translate(" + ( x_max - x_min + maxValue(widthArray) + 2*margin + rectH+marginLeft)/2  + "," + rectH + ")");
   
   // return the new height and  width to change the size of <div id="chart">
   return [heightUpdated,widthUpdated];
}
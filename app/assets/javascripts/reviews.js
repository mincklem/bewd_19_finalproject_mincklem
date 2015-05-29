$(document).ready(function(){
    var isbn;
	var stars = [];
	var user_excludes = [];
	var count;
    shareThis();
	
function shareThis(){
         var shelfPNG = 'http://i.imgur.com/52q0CK8.jpg'
         stWidget.addEntry({
                 "service":"twitter",
                 "element":document.getElementById('button_1'),
                 "url":"http://sharethis.com",
                 "title":"TWITTER TEXT",
                 "type":"large",
                 "text":"ShareThis" ,
                 "image":"http://www.softicons.com/download/internet-icons/social-superheros-icons-by-iconshock/png/256/sharethis_hulk.png",
                 "summary":"this is description1"
         });

         stWidget.addEntry({
                 "service":"facebook",
                 "element":document.getElementById('button_1'),
                 "url":"http://sharethis.com",
                 "title":"sharethis",
                 "type":"large",
                 "text":"FACEBOOK TEXT" ,
                 "image":'https://www.facebook.com/dialog/feed?_path=feed&app_id=487604788070849&redirect_uri=http://modernlibrary.webdev.us.randomhouse.com/Shelf_Builder/&display=popup&link=http://modernlibrary.webdev.us.randomhouse.com/Shelf_Builder/&picture='+shelfPNG+'',
                 "summary":"this is description1"
         });
                  stWidget.addEntry({
                 "service":"pinterest",
                 "element":document.getElementById('button_1'),
                 "url":"http://sharethis.com",
                 "title":"PINTEREST TEXT",
                 "type":"large",
                 "text":"ShareThis" ,
                 "image":"http://www.softicons.com/download/internet-icons/social-superheros-icons-by-iconshock/png/256/sharethis_hulk.png",
                 "summary":"this is description1"
         });
}

    function starButton(){
		// get user star filter
		$('button[type="button"').click(function(){
	    	if ($(this).hasClass("selected")) {
	    		$(this).removeClass("selected").css("background-color", "white");
	    		stars.splice($.inArray($(this).attr('id'), stars), 1)
	    	} else {
	    	$(this).addClass("selected").css("background-color", "rgb(230, 230, 230)");
	    	stars.push($(this).attr('id'))
	    	}
		});
	}

	function starSubmit(){
		$("#starSubmit").click(function(){
			// get user minimum term frequency
            $(".fa-pulse").css("visibility", "visible");
			count = $("#count_limit").val();
			// get user exclusions
			user_excludes = $("#user_excludes").val();
			console.log("sending stars");
			$.ajax({
			   type: "POST", 
			   url: 'reviews/stars',
			   beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
			   data: {"stars":stars, 
			   "count": count, 
			   "user_excludes":user_excludes},
			   success: function(response) {
			   	console.log(response);
                makeCloud(response);
			   }
		 	});
		});
	};

function makeCloud(h) {
$(".wordCloudsBox").children().remove();
   $(".wordCloudsBox").jQCloud(h, {
    });
    $(".fa-pulse").css("visibility", "hidden");
}

function shelvesCount(h){
    $("#shelvesTab").click(function(){
        // show loader
        $(".fa-pulse").css("visibility", "visible");
        console.log("getting shelves");
        console.log(isbn);
        $.ajax({
            type: "POST", 
            url: '/shelves',
           beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
           data: {"isbn":isbn}, 
           success: function(response) {
                console.log(response);
                if (response[0] == "false") {
                    console.log("not graphing");
                    $("#shelves_chart_box").css("display", "none");
                    $("#shelves").append("<div class='shelves_error'><h1>Sorry, Goodreads shelves counts are insufficient for this title, try another.</h1></div>");    
                } else  {
                    console.log("graphing");
                    graphAllShelves(response[0]);
                    graphRollShelves(response[1]);
                    $(".shelves_table tbody").remove();
                    tableShelves(response)
                }
            }
        });        
    })
}

function storeISBN() {
    $("input[value='Get Reviews'").click(function(){
        isbn = $("input[name='choice']").attr("value");
        console.log(isbn)
    })
}

function monkeyCall(r){
    $("#themesTab").click(function(){
    // show loader
    $(".fa-pulse").css("visibility", "visible");
    // get reviews text
    $.ajax({
        type: "POST", 
       url: '/monkey',
       beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
       data: {"isbn":isbn}, 
       success: function(response) {
        console.log(response);
        monkeyKeyWords(response)
               }
            });
    });
}

function monkeyKeyWords(response){
    var reviews = response
        $.ajax({
        url : "https://api.monkeylearn.com/v2/extractors/ex_y7BPYzNG/extract/",
        type : "POST",
        headers: {
            "Authorization": "token 935676726a9c5dee46805e9890680450e1132ff4",
        },
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify({
          text_list: [""+reviews+""]
        }),
        success : function(result) {
          console.log(result);
          graphMonkey(result);
        },
        error : function(e) {
          alert('Error: ' + e);
        }
    });
}

function monkeyThemes(response){
    var reviews = response
        $.ajax({
        url : "https://api.monkeylearn.com/v2/extractors/ex_y7BPYzNG/extract/",
        type : "POST",
        headers: {
            "Authorization": "token 935676726a9c5dee46805e9890680450e1132ff4",
        },
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify({
          text_list: [""+reviews+""]
        }),
        success : function(result) {
          console.log(result);
          graphMonkey(result)
        },
        error : function(e) {
          alert('Error: ' + e);
        }
    });
}

function activeTab(){	
	$('#myTab a').click(function (e) {
		    e.preventDefault();
		  $('this').tab('show')
	});
}

function showChoice(){
    $("input[value='Get Reviews']").click(function(){
        console.log("firing");
        $(".chosenTitle").css("display", "block")
    })

}

function tableShelves(result){
    $.each(result[1], function(i, val){
        $("#rolled_shelves_table").append("<tbody><td>"+i+"</td><td>"+val+"</td></tbody>");
    });
    $.each(result[0], function(i, val){
        $("#all_shelves_table").append("<tbody><td>"+i+"</td><td>"+val+"</td></tbody>");
    });
}

function graphAllShelves(result){
    console.log("graphing");
    var data_labels = [];
    var data_vals = [];
    $.each(result, function(i, val){
        data_labels.push(i);
        data_vals.push(val);
    });
    var data = {
        labels: data_labels.slice(0,20),
        datasets: [
            {
                label: "My First dataset",
                fillColor: "#1B4171",
                strokeColor: "#1B4171",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: data_vals.slice(0,20)
            }
        ]
    };
     var options = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero : true,

    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines : true,

    //String - Colour of the grid lines
    scaleGridLineColor : "rgba(0,0,0,.05)",

    //Number - Width of the grid lines
    scaleGridLineWidth : 1,

    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,

    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines: true,

    //Boolean - If there is a stroke on each bar
    barShowStroke : true,

    //Number - Pixel width of the bar stroke
    barStrokeWidth : 2,

    //Number - Spacing between each of the X value sets
    barValueSpacing : 5,

    //Number - Spacing between data sets within X values
    barDatasetSpacing : 1,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"

};
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#allShelvesChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    if (data_vals.length > 1) {
          var myBarChart = new Chart(ctx).Bar(data, options);
            console.log(myBarChart);
            console.log(data_vals);
            console.log(data_labels);
     $(".fa-pulse").css("visibility", "hidden");
    }; 
}

function graphRollShelves(result) {
    console.log("graphing");
    var data_labels = [];
    var data_vals = [];
    $.each(result, function(i, val){
        data_labels.push(i);
        data_vals.push(val);
    });
    var data = {
        labels: data_labels,
        datasets: [
            {
                label: "My First dataset",
                fillColor: "#1B4171",
                strokeColor: "#1B4171",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: data_vals
            }
        ]
    };
     var options = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero : true,

    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines : true,

    //String - Colour of the grid lines
    scaleGridLineColor : "rgba(0,0,0,.05)",

    //Number - Width of the grid lines
    scaleGridLineWidth : 1,

    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,

    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines: true,

    //Boolean - If there is a stroke on each bar
    barShowStroke : true,

    //Number - Pixel width of the bar stroke
    barStrokeWidth : 2,

    //Number - Spacing between each of the X value sets
    barValueSpacing : 5,

    //Number - Spacing between data sets within X values
    barDatasetSpacing : 1,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"

};
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#rollShelvesChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    // if (data_vals.length > 1) {
          var myBarChart = new Chart(ctx).Bar(data, options);
            console.log(myBarChart);
            console.log(data_vals);
            console.log(data_labels);
     $(".fa-pulse").css("visibility", "hidden");
    // }; 
}

function graphMonkey(result) {
    // breakout results for graphing
    console.log(result);
    var data_labels = [];
    var data_vals = [];
    $.each(result.result[0], function(i, val){
        data_labels.push(this.keyword);
        data_vals.push(this.relevance);
    });
    // convert string array to int array
    for(var i = 0; i < data_vals.length; i++)
        data_vals[i] = parseFloat(data_vals[i], 10);
    var data = {
        labels: data_labels,
        datasets: [
                {
                    label: "Goodreads Shelves",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "#1B4171",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#1B4171",
                    pointHighlightFill: "#1B4171",
                    pointHighlightStroke: "#1B4171",
                    data: data_vals
                },
            ]
        };
    var options = {
    //Boolean - Whether to show lines for each scale point
    scaleShowLine : true,

    //Boolean - Whether we show the angle lines out of the radar
    angleShowLineOut : true,

    //Boolean - Whether to show labels on the scale
    scaleShowLabels : false,

    // Boolean - Whether the scale should begin at zero
    scaleBeginAtZero : true,

    //String - Colour of the angle line
    angleLineColor : "rgba(0,0,0,.1)",

    //Number - Pixel width of the angle line
    angleLineWidth : 2,

    //String - Point label font declaration
    pointLabelFontFamily : "'Arial'",

    //String - Point label font weight
    pointLabelFontStyle : "normal",

    //Number - Point label font size in pixels
    pointLabelFontSize : 14,

    //String - Point label font colour
    pointLabelFontColor : "#666",

    //Boolean - Whether to show a dot for each point
    pointDot : true,

    //Number - Radius of each point dot in pixels
    pointDotRadius : 3,

    //Number - Pixel width of point dot stroke
    pointDotStrokeWidth : 1,

    //Number - amount extra to add to the radius to cater for hit detection outside the drawn point
    pointHitDetectionRadius : 20,

    //Boolean - Whether to show a stroke for datasets
    datasetStroke : true,

    //Number - Pixel width of dataset stroke
    datasetStrokeWidth : 3,

    //Boolean - Whether to fill the dataset with a colour
    datasetFill : true,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].strokeColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
    }
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#keywordsChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    var myRadarChart = new Chart(ctx).Radar(data, options);
     $(".fa-pulse").css("visibility", "hidden");
}

showChoice();
storeISBN();
shelvesCount();
monkeyCall();
activeTab();
starButton();
starSubmit();
})

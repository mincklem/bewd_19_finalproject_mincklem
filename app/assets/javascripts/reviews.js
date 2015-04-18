$(document).ready(function(){
    var isbn;
	var stars = [];
	var user_excludes = [];
	var count;
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
        console.log("getting shelves");
        console.log(isbn);
        $.ajax({
            type: "POST", 
            url: '/shelves',
           beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
           data: {"isbn":isbn}, 
           success: function(response) {
            console.log(response);
            // monkeyKeyWords(response);
            // // monkeyThemes(response)
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
    // get reviews text
    $.ajax({
        type: "POST", 
       url: '/monkey',
       beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
       data: {"isbn":isbn}, 
       success: function(response) {
        console.log(response);
        monkeyKeyWords(response);
        // monkeyThemes(response)
               }
            });

    // 
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
          graph(result);
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
          graph(result)
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

function graph(result) {
    // breakout results for graphing
    var data_labels = [];
    var data_vals = [];
    $.each(result.result[0], function(i, val){
        data_labels.push(this.keyword);
        data_vals.push(this.relevance);
    });
    // convert string array to int array
    for(var i = 0; i < data_vals.length; i++)
        data_vals[i] = parseFloat(data_vals[i], 10);
    console.log(data_labels);
    console.log(data_vals);
    var data = {
        labels: data_labels,
        datasets: [
                {
                    label: "My First dataset",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "#1B4171",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#1B4171",
                    pointHighlightFill: "#1B4171",
                    pointHighlightStroke: "#1B4171",
                    data: data_vals
                },
                // {   
                //     label: "My Second dataset",
                //     fillColor: "rgba(151,187,205,0.2)",
                //     strokeColor: "rgba(151,187,205,1)",
                //     pointColor: "rgba(151,187,205,1)",
                //     pointStrokeColor: "#fff",
                //     pointHighlightFill: "#fff",
                //     pointHighlightStroke: "rgba(151,187,205,1)",
                //     data: [28, 48, 40, 19, 96, 27, 100]
                // }
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
    scaleBeginAtZero : false,

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
    var ctx = $("#themesChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    var myRadarChart = new Chart(ctx).Radar(data, options);
}

showChoice();
storeISBN();
shelvesCount();
monkeyCall();
activeTab();
starButton();
starSubmit();
})

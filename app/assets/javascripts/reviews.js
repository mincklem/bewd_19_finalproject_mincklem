$(document).ready(function(){
	var stars = [];
	var user_excludes = [];
	var count;
	function starButton(){
		// get user star filter
		$('div[type="button"').click(function(){
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
			   		var hash_response = response;
				   	var h = new HashTable(hash_response);
				   	// wordCloudFontSizes(h);
				   	$(".word").remove();
				   	h.each(function(k, v) {
					$(".wordCloudsBox").append('<div class="word"><br> term : ' + k + ', times: ' + v + '<br></div>');
					});
			   }
		 	});
		});
	};

function wordCloudFontSizes(h) {
	term_nums = [];
	h.each(function(k, v) {
		term_nums.push(v)
	});		
	console.log(term_nums)

}

function HashTable(obj){
    this.length = 0;
    this.items = {};
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            this.items[p] = obj[p];
            this.length++;
        }
    }

    this.setItem = function(key, value)
    {
        var previous = undefined;
        if (this.hasItem(key)) {
            previous = this.items[key];
        }
        else {
            this.length++;
        }
        this.items[key] = value;
        return previous;
    }

    this.getItem = function(key) {
        return this.hasItem(key) ? this.items[key] : undefined;
    }

    this.hasItem = function(key)
    {
        return this.items.hasOwnProperty(key);
    }
   
    this.removeItem = function(key)
    {
        if (this.hasItem(key)) {
            previous = this.items[key];
            this.length--;
            delete this.items[key];
            return previous;
        }
        else {
            return undefined;
        }
    }

    this.keys = function()
    {
        var keys = [];
        for (var k in this.items) {
            if (this.hasItem(k)) {
                keys.push(k);
            }
        }
        return keys;
    }

    this.values = function()
    {
        var values = [];
        for (var k in this.items) {
            if (this.hasItem(k)) {
                values.push(this.items[k]);
            }
        }
        return values;
    }

    this.each = function(fn) {
        for (var k in this.items) {
            if (this.hasItem(k)) {
                fn(k, this.items[k]);
            }
        }
    }

    this.clear = function()
    {
        this.items = {}
        this.length = 0;
    }
}

	function activeTab(){	
		$('#myTab a').click(function (e) {
		    e.preventDefault();
		  $('this').tab('show')
		});
	}

activeTab;
starButton();
starSubmit();
})

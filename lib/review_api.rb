module ReviewApi
	class CalledReviews
		
		def gr_reviews(isbn)
			@gr_reviews_array = []
			@isbn = isbn
			@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=book_id&result_type=goodreads&page=1"
			response = JSON.load(RestClient.get(@api_url))
			puts response
	  		response.each do |rev|
	    		mapped_review = {
	    			isbn: @isbn,
	    			rating: rev["rating"],
	    			review_text: rev["review_text"],
	    			user: rev["user"],
	    			platform: "Goodreads",
	    			review_date: rev["date"]}
	    		@gr_reviews_array.push(mapped_review)
			end
			@gr_reviews_array
		end

		def amz_reviews(isbn)
			@amz_reviews_array = []
			@isbn = isbn
			1.times do |num| 
				@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=book_id&result_type=amazon&page=#{num+1}"
				puts @api_url
				response = JSON.load(RestClient.get(@api_url))
				puts response
		  		response.each do |rev|
		    		mapped_review = {isbn: @isbn,
		    			rating: rev["rating"],
		    			review_text: rev["review_text"],
		    			user: rev["user"],
		    			platform: "Amazon",
		    			review_date: rev["date"]}
		    		@amz_reviews_array.push(mapped_review)
				end
			end
			@amz_reviews_array
		end

	end
end


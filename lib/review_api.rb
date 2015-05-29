module ReviewApi
	class CalledReviews
		##reviews only return first 300 characters, but each review sample has a link to the full text, a URL with a specific review ID, which we want.  This function extracts those IDs:
		def gr_reviews(isbn)
			@gr_reviews_array = []
			@isbn = isbn
			@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=isbn&result_type=goodreads&page=1"
			response = JSON.load(RestClient.get(@api_url))
	  		response.each do |rev|
	    		mapped_review = {isbn: @isbn,
	    			rating: rev["rating"],
	    			review_text: rev["review_text"],
	    			user: rev["user"],
	    			review_date: rev["date"]}
	    		@gr_reviews_array.push(mapped_review)
			end
			@gr_reviews_array
		end

		def amz_reviews(isbn)
			@amz_reviews_array = []
			@isbn = isbn
			@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=isbn&result_type=amazon&page=1"
			response = JSON.load(RestClient.get(@api_url))
	  		response.each do |rev|
	    		mapped_review = {isbn: @isbn,
	    			rating: rev["rating"],
	    			review_text: rev["review_text"],
	    			user: rev["user"],
	    			review_date: rev["date"]}
	    		@amz_reviews_array.push(mapped_review)
			end
			@amz_reviews_array
		end

	end
end

		#get single review using nokogiri, potentially faster????
		# def single_greads_review(id)
		# 	@html_doc = Nokogiri::HTML(open("https://www.goodreads.com/review/show/#{id}"))
		# 	@single_full_review = @html_doc.css("div.description")
		# 	puts @single_full_review
		# end

#get plain goodreads API (widget)
		# def greads_API(isbn)
		# 	greads_API = "https://www.goodreads.com/book/isbn?format=json&key=LbfI8uwSm3Hd7X4Q1VoDsA&isbn=#{isbn}"
		# 	greads_raw_output = RestClient.get(greads_API)
		# 	greads_json_output = JSON.load(greads_raw_output)
		# 	puts greads_json_output
		# end


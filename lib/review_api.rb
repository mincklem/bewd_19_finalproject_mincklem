module ReviewApi
	class CalledReviews
		##reviews only return first 300 characters, but each review sample has a link to the full text, a URL with a specific review ID, which we want.  This function extracts those IDs:
		def call_reviews(clean_isbn)
			@reviews_array = []
			@isbn = clean_isbn
			puts @isbn
			#SAMPLING FROM REDDIT 
			response = JSON.load(RestClient.get('https://www.reddit.com/.json'))
	  		response["data"]["children"].each do |rev|
	    		mapped_review = {isbn: rev["data"]["created"],
	    			title: rev["data"]["author"], 
	    			review_text: rev["data"]["title"],
	    			likes: rev["data"]["ups"],
	    			shelves: rev["data"]["subreddit"]}
	    		@reviews_array.push(mapped_review)
			end
			@reviews_array
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


module ShelvesApi
	class CalledShelves
		def call_shelves(clean_isbn)
			@reviews_array = []
			@isbn = clean_isbn
			puts @isbn
			#SAMPLING FROM REDDIT 
			response = JSON.load(RestClient.get('http://www.reddit.com/.json'))
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
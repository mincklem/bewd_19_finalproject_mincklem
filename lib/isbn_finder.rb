# I got this from the Google Books API Family!
# https://developers.google.com/books/docs/v1/using

module ISBN
	  # def self.find_isbn(user_search)
	  #   results = JSON.load RestClient.get "https://www.googleapis.com/books/v1/volumes?q=#{user_search}"
	  #   @books = results["items"]
	  #   return results["items"]
	  # end

	 def self.find_isbn(user_search)
	    results = RestClient.get "https://www.goodreads.com/search/index.xml?key=LbfI8uwSm3Hd7X4Q1VoDsA&q=#{user_search}"
	    @json = JSON.load(Hash.from_xml(results).to_json)
	    return @json
	  end

	  def self.book_number(number)
	    return @books[number]["volumeInfo"]["industryIdentifiers"].first["identifier"]
	  end
end

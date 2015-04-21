# I got this from the Google Books API Family!
# https://developers.google.com/books/docs/v1/using

module ISBN
	  def self.find_isbn(user_search)
	    results = JSON.load RestClient.get "//www.googleapis.com/books/v1/volumes?q=#{user_search}"
	    @books = results["items"]
	    return results["items"]
	  end

	  def self.book_number(number)
	    return @books[number]["volumeInfo"]["industryIdentifiers"].first["identifier"]
	  end
end

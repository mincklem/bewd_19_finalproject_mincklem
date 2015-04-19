module ShelvesApi
		def self.call_shelves(isbn)
			#getting Goodreads work ID
			xml = RestClient.get "https://www.goodreads.com/search/index.xml?key=LbfI8uwSm3Hd7X4Q1VoDsA&q=#{isbn}"
	  		@json = JSON.load(Hash.from_xml(xml).to_json)
	  		@work_id = @json["GoodreadsResponse"]["search"]["results"]["work"]["id"]
	  		puts @work_id
	  		2.times do |num|
	  			@response = JSON.load(RestClient.get("https://api.import.io/store/data/e33f6a3a-38c7-4b1e-8a84-719a48bd959c/_query?input/webpage/url=https%3A%2F%2Fwww.goodreads.com%2Fwork%2Fshelves%2F#{@work_id}%2F%3Fpage%3D#{num}&_user=b9d01559-2134-4d25-ab73-50773a60cc75&_apikey=b9d01559-2134-4d25-ab73-50773a60cc75%3A%2BSAXX3%2BaiNbbx74UKfrSCWIWJrAUpSzuDkjtYtaAYVFtqf1R5lE41igQU08aG07bDEDwCMF57T2x9avAqbe%2BOw%3D%3D"))
	  		end
	  		puts @response
	  		if @response["errorType"] == "NotFoundException"
	  			puts "Book not found"
	  		else 
	  			@keys = []
				@values = []
		  		@response["results"].each do |two_columns|
					two_columns["my_column_2/_source"].each do |this|
		  				@keys.push(this.split("=")[1].downcase)
		  			end
		  			two_columns["my_column_2/_text"].each do |this|
		  				@values.push(this.split(" ")[0])
		  			end
		  		end
	  			@zipped = @keys.zip(@values)
				@h = Hash[@zipped]
				puts @h
				@h
	  		end
		end

end
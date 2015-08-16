module ShelvesApi
		def self.call_shelves(isbn)
		
			#getting Goodreads work ID
			xml = RestClient.get "https://www.goodreads.com/book/show/#{isbn}?format=xml&key=LbfI8uwSm3Hd7X4Q1VoDsA"
	  		@json = JSON.load(Hash.from_xml(xml).to_json)
	  		@work_id = @json["GoodreadsResponse"]["book"]["work"]["id"]
	  		@shelves_all_pages = {}
	  		7.times do |num|
	  			import_api = "https://api.import.io/store/data/e33f6a3a-38c7-4b1e-8a84-719a48bd959c/_query?input/webpage/url=https%3A%2F%2Fwww.goodreads.com%2Fwork%2Fshelves%2F#{@work_id}%2F%3Fpage%3D#{num+1}&_user=b9d01559-2134-4d25-ab73-50773a60cc75&_apikey=b9d01559-2134-4d25-ab73-50773a60cc75%3A%2BSAXX3%2BaiNbbx74UKfrSCWIWJrAUpSzuDkjtYtaAYVFtqf1R5lE41igQU08aG07bDEDwCMF57T2x9avAqbe%2BOw%3D%3D"
	  			puts import_api
	  			@response = JSON.load(RestClient.get(import_api))
	  			puts @response
		  		if @response["errorType"] == "NotFoundException"
		  			puts "Book not found"
		  		else 
		  			@keys = []
					@values = []
			  		@response["results"].each do |two_columns|
						#if more than one shelf IN SOURCE
						if two_columns["my_column_2/_source"].class == Array
							two_columns["my_column_2/_source"].each do |this|
			  					@keys.push(this.split("=")[1].downcase)
			  				end
						#if less than one shelf IN SOURCE
						else
							two_columns["my_column_2/_source"].split("=")[1].downcase
						end
						
						#if more than one shelf IN TEXT
						if two_columns["my_column_2/_text"].class == Array
							two_columns["my_column_2/_text"].each do |this|
			  					@values.push(this.split(" ")[0])
			  				end
						#if less than one shelf IN TEXT
						else
							two_columns["my_column_2/_text"].split(" ")[0]
						end
			  		end
		  			@zipped = @keys.zip(@values)
					@h = Hash[@zipped]
					puts "===================@H=============================="
					puts @h
					@shelves_all_pages = @shelves_all_pages.merge(@h) 
					puts "===================@Merge=============================="
					puts @shelves_all_pages
		  		end
			end
			@shelves_all_pages
		end

end
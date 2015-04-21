class Monkey
	def monkey_theme(reviews)
		@reviews = reviews
		uri = URI.parse("https://api.monkeylearn.com/v2/classifiers/cl_rizNHGx2/classify/?sandbox=1")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(uri.request_uri)
		 
		# Set POST data
		request.body = {text_list: ["#{@reviews}"]}.to_json
		# Set headers
		request.add_field("Content-Type", "application/json")
		request.add_field("Authorization", "token 935676726a9c5dee46805e9890680450e1132ff4")
		 
		@monkey_themes = http.request(request).body
		puts @monkey_themes
	end

	def monkey_keywords (reviews)
		@reviews = reviews 
			uri = URI.parse("https://api.monkeylearn.com/v2/extractors/ex_y7BPYzNG/extract/")
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			request = Net::HTTP::Post.new(uri.request_uri)
			 
			# Set POST data
			request.body = {text_list: ["#{@reviews}"]}.to_json
			# Set headers
			request.add_field("Content-Type", "application/json")
			request.add_field("Authorization", "token 935676726a9c5dee46805e9890680450e1132ff4")
			 
			@monkey_keywords = http.request(request).body
			puts @monkey_keywords

end

end


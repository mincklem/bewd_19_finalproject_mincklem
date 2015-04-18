class ShelvesController < ApplicationController
	include ShelvesApi
	
	def index
		@shelves = Shelf.all
	end
	
	def shelves
	  	if session[:isbn]
			@isbn = session[:isbn]
		else
		end
	  	puts "hitting shelves"
	  	puts @isbn
	  	@shelves_hash = ShelvesApi.call_shelves(@isbn)
	  	puts @shelves_hash
		@new = Shelf.new
		@shelves_hash.each do |key, value|
  			@added_shelf = Shelf.create(
				isbn: @isbn,
  				shelves: key,
  				value: value)
  				puts @added_shelf
  		end

  		redirect_to "/shelves"
  	# 	@json_shelves = @shelves_hash.to_json
	  # 	respond_to do |format|
			# format.json { render json: @json_shelves }
			# format.js   { render json: @json_shelves }
		# end
  	end
end

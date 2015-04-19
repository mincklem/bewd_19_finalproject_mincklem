class ShelvesController < ApplicationController
	include ShelvesApi
	
	def index
		@shelves = Shelf.all
	end

	def shelves
	  	if session[:isbn]
		@isbn = session[:isbn]
		end

		if Shelf.exists?(isbn:@isbn)
			@search_result = Shelf.count_shelves(@isbn)
		else
			Shelf.get_shelves(@isbn)
			@search_result = Shelf.count_shelves(@isbn)

		end
		
		@json_shelves = @search_result.to_json
		respond_to do |format|
			format.json { render json: @json_shelves }
			format.js   { render json: @json_shelves }
		end
	end
	
end

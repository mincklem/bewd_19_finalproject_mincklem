class ShelvesController < ApplicationController
	include ShelvesApi
	
	def index
		@shelves = Shelf.all
	end

	def shelves
	  	if session[:isbn]
		@isbn = session[:isbn]
		end
		#if book exists in db, delete current records, and repull
		if Shelf.exists?(isbn: @isbn)
			puts "Exists already"
			Shelf.destroy_all(isbn: @isbn)
			@search_result = Shelf.count_shelves(@isbn)
		#if book has not been called before, call and count
		else
			#check if goodreads fails to return shelves
			@status = Shelf.get_shelves(@isbn)
			#if goodreads fails
			if @status[:status] == false
				puts "not counting"
				@search_result = ["false"]
			#if goodreads succeeds
			else	
				puts "counting"
				@search_result = Shelf.count_shelves(@isbn)
			end
		end
		
		@json_shelves = @search_result.to_json
		respond_to do |format|
			format.json { render json: @json_shelves }
			format.js   { render json: @json_shelves }
		end
	end
	
end

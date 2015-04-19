class Shelf < ActiveRecord::Base

	def self.get_shelves(isbn)
		@isbn = isbn
		puts "hitting shelves"
	  	puts @isbn
	  	@shelves_hash = ShelvesApi.call_shelves(@isbn)
	  	puts @shelves_hash
		@new = Shelf.new
		@shelves_hash.each do |key, value|
  			@added_shelf = Shelf.create(
				isbn: @isbn.to_i,
  				shelves: key,
  				value: value.delete(","))
  		end
	end

	def self.count_shelves(isbn)
		@isbn = isbn

  		@sci_count = 0
  		@rom_count = 0
  		@mys_count = 0
  		@lit_count = 0
  		@par_count = 0
  		@wom_count = 0
  		@ser_count = 0
  		@hum_count = 0
  		@hor_count = 0
  		@fic_count = 0
  		@class_count = 0

  		#Science Fiction
  		@scifi = Shelf.where(isbn: @isbn).where("shelves LIKE '%scifi%' OR shelves LIKE '%sci-fi%'OR shelves LIKE '%sci/fi%'OR shelves LIKE '%science%'")
  		@scifi.each do |this|
  			@sci_count = @sci_count + this.value.to_i
  		end
  		#Romance 
  		@rom = Shelf.where(isbn: @isbn).where("shelves LIKE '%romance%' OR shelves LIKE '%love%' OR shelves LIKE '%sex%'OR shelves LIKE '%hunk%' OR shelves LIKE '%swoon%' OR shelves LIKE '%hot%'OR shelves LIKE '%steam%'OR shelves LIKE '%erotic%' OR shelves LIKE '%pleasure%' OR shelves LIKE '%dreamy%'OR shelves LIKE '%dirty%'OR shelves LIKE '%heart%'")
  		@rom.each do |this|
  			@rom_count = @rom_count + this.value.to_i
  		end

  		#Mystery-Thriller 
  		@mys = Shelf.where(isbn: @isbn).where("shelves LIKE '%mystery%' OR shelves LIKE '%thriller%' OR shelves LIKE '%suspense%'")
  		@mys.each do |this|
  			@mys_count = @mys_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Women/Heroines
  		@wom = Shelf.where(isbn: @isbn).where("shelves LIKE '%woman%' OR shelves LIKE '%women%' OR shelves LIKE '%heroin%' OR shelves LIKE '%female%' OR shelves LIKE '%girl%'")
  		@wom.each do |this|
  			@wom_count = @wom_count + this.value.to_i
  			puts this.value.to_i
  		end

  		@search_result = {:Science_Fiction => @sci_count, 
  			:Romance => @rom_count,
  			:Mystery_Thriller => @mys_count,
  			:Paranormal =>@par_count,
  			:Women=>@wom_count,
  			:Literature=>@lit_count,
	  		:Humor=>@hum_count,
	  		:Horror=>@hor_count,
	  		:Fiction=>@fic_count,
	  		:Classic=>@class_count
  		}
  		puts @search_result
  		@search_result
  	end
end

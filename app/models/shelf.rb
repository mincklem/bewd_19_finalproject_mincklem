class Shelf < ActiveRecord::Base

	def self.get_shelves(isbn)
		@isbn = isbn
		puts "hitting shelves"
	  puts @isbn
	  @shelves_hash = ShelvesApi.call_shelves(@isbn)
	  puts @shelves_hash
		if @shelves_hash["status"] = false
        puts "bad Goodreads"
        @status = {:status => false}
        return @status
    else
        @new = Shelf.new
        @shelves_hash.each do |key, value|
          if value != false
            @added_shelf = Shelf.create(
            isbn: @isbn.to_i,
            shelves: key,
            value: value.delete(",")) 
          end
        end
    end
	end

	def self.count_shelves(isbn)
		@isbn = isbn
		@all_shelves = Shelf.where(isbn: @isbn)
		@all_hash = {}
		@all_shelves.each do |this|
			if (this.shelves != "to-read") && (this.shelves !~ /\d/)  && (this.shelves != "to read")
           @shelf = this.shelves
            @val = this.value
            @all_hash[:"#{@shelf}"] = @val
      end
		end
		  puts @all_hash
		  #Category Roll-up Counts
  		@sci_count = 0
  		@rom_count = 0
  		@mys_count = 0
  		@lit_count = 0
  		@para_count = 0
  		@wom_count = 0
  		@ser_count = 0
  		@hum_count = 0
  		@hor_count = 0
  		@fic_count = 0
  		@class_count = 0
  		@ser_count = 0
  		@ya_count = 0
  		@chick_count = 0
      @child_count = 0
      @hist_count = 0
      @bookclub_count = 0
      @brit_count = 0
      @culture_count = 0 
      @contemp_count = 0
  		#Category Roll-up search functions

  		#Science Fiction
  		@scifi = Shelf.where(isbn: @isbn).where("shelves LIKE '%scifi%' OR shelves LIKE '%sci-fi%'OR shelves LIKE '%sci/fi%'OR shelves LIKE '%science%'OR shelves LIKE '%dystop%'OR shelves LIKE '%apoc%'OR shelves LIKE '%distopi%'")
  		@scifi.each do |this|
  			@sci_count = @sci_count + this.value.to_i
  		end
  		#Romance 
  		@rom = Shelf.where(isbn: @isbn).where("shelves LIKE '%romance%' OR shelves LIKE '%love%' OR shelves LIKE '%sex%'OR shelves LIKE '%hunk%' OR shelves LIKE '%swoon%' OR shelves LIKE '%hot%'OR shelves LIKE '%steam%'OR shelves LIKE '%erotic%' OR shelves LIKE '%pleasure%' OR shelves LIKE '%dreamy%'OR shelves LIKE '%dirty%'OR shelves LIKE '%heart%'")
  		@rom.each do |this|
  			@rom_count = @rom_count + this.value.to_i
  		end

  		#Mystery-Thriller 
  		@mys = Shelf.where(isbn: @isbn).where("shelves LIKE '%mystery%' OR shelves LIKE '%thriller%' OR shelves LIKE '%suspense%'OR shelves LIKE '%action%'")
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
  		#Literary
  		@lit = Shelf.where(isbn: @isbn).where("shelves LIKE '%liter%'")
  		@lit.each do |this|
  			@lit_count = @lit_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Humor
  		@hum = Shelf.where(isbn: @isbn).where("shelves LIKE '%funny%' OR shelves LIKE '%lol%' OR shelves LIKE '%humor%'OR shelves LIKE '%humour%' OR shelves LIKE '%laugh%' OR shelves LIKE '%hilarious%'OR shelves LIKE '%comedy%'OR shelves LIKE '%comic%' OR shelves LIKE '%amusing%' OR shelves LIKE '%amuse%'OR shelves LIKE '%funn%'")
  		@hum.each do |this|
  			@hum_count = @hum_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Horror
  		@hor = Shelf.where(isbn: @isbn).where("shelves LIKE '%horror%' OR shelves LIKE '%ghost%' OR shelves LIKE '%scary%'OR shelves LIKE '%occult%' OR shelves LIKE '%gothic%' OR shelves LIKE '%macabre%'OR shelves LIKE '%terror%'OR shelves LIKE '%fear%' OR shelves LIKE '%spook%' OR shelves LIKE '%creep%'OR shelves LIKE '%eerie%'OR shelves LIKE '%creepy%' OR shelves LIKE '%fright%'OR shelves LIKE '%chilling%'OR shelves LIKE '%ghoul%'OR shelves LIKE '%demon%'OR shelves LIKE '%devil%'OR shelves LIKE '%terrif%'OR shelves LIKE '%haunt%'OR shelves LIKE '%dark%'OR shelves LIKE '%monster%'")
  		@hor.each do |this|
  			@hor_count = @hor_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Fiction
  		@fic = Shelf.where(isbn: @isbn).where("shelves LIKE '%fiction%'")
  		@fic.each do |this|
  			@fic_count = @fic_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Classics
  		@class = Shelf.where(isbn: @isbn).where("shelves LIKE '%classic%'")
  		@class.each do |this|
  			@class_count = @class_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Series
  		@series = Shelf.where(isbn: @isbn).where("shelves LIKE '%series%'")
  		@series.each do |this|
  			@ser_count = @ser_count + this.value.to_i
  			puts this.value.to_i	
  		end
  		#Paranormal/Fantasy
  		@para = Shelf.where(isbn: @isbn).where("shelves LIKE '%paranormal%' OR shelves LIKE '%fairy%' OR shelves LIKE '%fantas%'OR shelves LIKE '%occult%' OR shelves LIKE '%faerie%' OR shelves LIKE '%fairies%'OR shelves LIKE '%magic%'OR shelves LIKE '%fae%' OR shelves LIKE '%elves%' OR shelves LIKE '%elf%'OR shelves LIKE '%magic%'OR shelves LIKE '%supernatural%' OR shelves LIKE '%fantas%'OR shelves LIKE '%vampire%'OR shelves LIKE '%immortal%' OR shelves LIKE '%monster%'")
  		@para.each do |this|
  			@para_count = @para_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Young Adult 
  		@ya = Shelf.where(isbn: @isbn).where("shelves LIKE '%youngadult%' OR shelves LIKE '%young adult%' OR shelves LIKE '%ya%'OR shelves LIKE '%young-adult%' OR shelves LIKE '%teen%'")
  		@ya.each do |this|
  			@ya_count = @ya_count + this.value.to_i
  			puts this.value.to_i
  		end
  		#Chick-Lit
  		@chick = Shelf.where(isbn: @isbn).where("shelves LIKE '%chick%'")
  		@chick.each do |this|
  			@chick_count = @chick_count + this.value.to_i
  			puts this.value.to_i
  		end
      @child = Shelf.where(isbn: @isbn).where("shelves LIKE '%child%' OR shelves LIKE '%kid%'")
      @child.each do |this|
        @child_count = @child_count + this.value.to_i
        puts this.value.to_i
      end
       @hist = Shelf.where(isbn: @isbn).where("shelves LIKE '%hist%'")
      @hist.each do |this|
        @hist_count = @hist_count + this.value.to_i
        puts this.value.to_i
      end
      @bookclub = Shelf.where(isbn: @isbn).where("shelves LIKE '%club%'OR shelves LIKE '%group%'")
      @bookclub.each do |this|
        @bookclub_count = @bookclub_count + this.value.to_i
        puts this.value.to_i
      end
      @brit = Shelf.where(isbn: @isbn).where("shelves LIKE '%brit%' OR shelves LIKE '%engl%' OR shelves LIKE '%euro%' OR shelves LIKE '%uk%'")
      @brit.each do |this|
        @brit_count = @brit_count + this.value.to_i
        puts this.value.to_i
      end
      @culture = Shelf.where(isbn: @isbn).where("shelves LIKE '%cultur%'")
      @culture.each do |this|
        @culture_count = @culture_count + this.value.to_i
        puts this.value.to_i
      end
        @contemp = Shelf.where(isbn: @isbn).where("shelves LIKE '%contemp%'")
        @contemp.each do |this|
        @contemp_count = @contemp_count + this.value.to_i
        puts this.value.to_i
      end
      

  		@search_result = {:Science_Fiction => @sci_count, 
  			:Romance => @rom_count,
  			:Mystery_Thriller => @mys_count,
  			:Fantasy_Paranormal =>@para_count,
  			:Women=>@wom_count,
  			:Literature=>@lit_count,
	  		:Humor=>@hum_count,
	  		:Horror=>@hor_count,
	  		:Fiction=>@fic_count,
	  		:Classic=>@class_count,
	  		:Series=>@ser_count,
	  		:Young_Adult=>@ya_count,
	  		:Chick_Lit=>@chick_count,
        :Childrens=>@child_count,
        :History=>@hist_count,
        :Britain_England=>@brit_count,
        :BookClub=>@bookclub_count,
        :Multicultural=>@culture_count,
        :Contemporary=>@contemp_count
  		}
  		puts @search_result
  		@returned_result = [@all_hash.sort_by {|_key, value| value}.reverse.to_h, @search_result.sort_by {|_key, value| value}.reverse.to_h]
  		puts @returned_result
  		@returned_result
  	end
end

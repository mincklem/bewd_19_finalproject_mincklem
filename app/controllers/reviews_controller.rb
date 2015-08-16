

class ReviewsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :xml, :json

  	include ReviewApi
  	include WordCloud
  	include ISBN

	def index
  		if session[:isbn].class == NilClass
  			redirect_to "/welcome" 
  		else
	  		@review = Review.new
	  		@goodreads_id = session[:isbn]
	  		@reviews = Review.where("(isbn IS #{@goodreads_id}) AND (review_text LIKE :query OR title LIKE :query)", 
	  		query: "%#{params[:search]}%")
	  		@img = session[:img]
	  		@title = session[:title]
	  		@author = session[:author]
	  		@date = session[:date]
			@recent_titles = "THESE ARE RECENT TITLES #{current_user.recent_titles}"
			@my_lists = "THESE ARE MY LISTS #{current_user.my_lists}"
		if current_user
  			@user = User.find_by(email: current_user.email)
		    # SETTING RECENT TITLES 
		    # if no recent titles
		    if @user.recent_titles.nil?
				  @user.recent_titles = session[:isbn]
			# if recent titles already
			else
				# if session ISBN already exists in recent array, do NOT add
				if @user.recent_titles.include?(session[:isbn])
					puts "ALREADY EXISTS"
					@user.save
				# if session ISBN is new, then add
				else
					@user.recent_titles << session[:isbn]
					puts "NEW BOOK, ADDING"
				end
			end
		     puts "SEARCHING #{@user.recent_titles}"
			@user.save
		     # @user.update(recent_titles: => @goodreads_id)

		else
		   redirect_to new_user_session_path, notice: 'You are not logged in.'
		end
  		end
  	end


    def show
  	@review = Review.find(params[:id])
  	end

  	def new
  	@review = Review.new
  	end

  	def create
		@goodreads_id = params[:choice]
		puts @goodreads_id
		  #get isbn from session if it is blank
		  params[:choice] ||= session[:isbn]
		  #save isbn to session for future requests
		  session[:isbn] = params[:choice]
			session[:img] = params[:img]
			session[:title] = params[:title]
			session[:author] = params[:author]
		#check if book has been called recently
			if Review.where(:isbn => params[:choice]).blank? && Review.where(["created_at < ?", 7.days.ago])
				api_reviews = ReviewApi::CalledReviews.new
				# ========= GET AMAZON REVIEWS =========== 
				@amz_review_array = api_reviews.amz_reviews(@goodreads_id)
				# ========= GET GOODREADS REVIEWS ===========
				@gr_review_array = api_reviews.gr_reviews(@goodreads_id)
				# ========= COMBINE REVIEWS =========== 
				@reviews_array = @gr_review_array.push(*@amz_review_array)
				@reviews_array.each_with_index do |this|
						isbn = this[:isbn]
						rating = this[:rating]
						review_text = this[:review_text]
						# user = this[:user]
						platform = this[:platform]
						title = params[:title].to_s		
						date = params[:date].to_s
					@added_review = Review.create(
							isbn: isbn, 
							title: title,
							date: date,
							# user: user, 
							review_text: review_text,
							platform: platform,
							star_rating: rating)
				end
			else
				puts "ALREADY SEARCHED"
			end	
	# Add selection to Recently Viewed Titles
			if current_user
		     @user = User.where()
		     puts current_user	
		     current_user.recent_titles == @goodreads_id
		     puts current_user.recent_titles
		     puts "adding title"
		   else
		     redirect_to new_user_session_path, notice: 'You are not logged in.'
			end
		redirect_to "/" 
  	end
  	def star_rating_filter
  		#get star filtered reviews text
	  	@user_cloud_prefs = [stars: params[:stars], count: params[:count], user_excludes: params[:user_excludes]]
  		#pass to wordcounter
		new_count = WordCloud::WordCount.new(@user_cloud_prefs)
		@goodreads_id = session[:isbn]
		@top_terms = new_count.get_reviews_by_stars(@goodreads_id)
		@arr = []
		@top_terms.each do |k,v|
		  @arr << {:text => k, :weight => v}
		end
		@arr.to_json
		#return to view 
		respond_to do |format|
		  format.json { render json: @arr }
		  format.js   { render json: @arr }
		end

  end
  
  def monkey
  	@goodreads_id = session[:isbn]
  	@reviews = Review.where("isbn LIKE '%#{@goodreads_id}%'")
  	@all_reviews_array = []
  	@reviews.each do |review|
		@text = review.review_text.downcase.gsub(",", "")
		@all_reviews_array.push(@text)
	end
	@all_reviews_text = @all_reviews_array.to_sentence
	#EXCLUDE TITLE AND AUTHOR 
	@exclude_array = [session[:author].split(" ").concat(session[:title].split(" "))]
	@exclude_array[0].each do |term|
		dwn_term = term.downcase.gsub(/[^a-z0-9\s]/i, '')
		puts "=========== #{dwn_term}"
		@all_reviews_text = @all_reviews_text.gsub(dwn_term, " ")
	end
	
	@all_reviews_pass = @all_reviews_text.split(",")
  	  	puts @all_reviews_pass
 #  	# ALSO PASSING TO Aylien for Language Processing
 #  	puts "==================================="
 #  	textapi = AylienTextApi::Client.new(app_id: "acc6e1de", app_key: "4b473c59aac49191eab44d2ac151e679")
	# @text = @all_reviews_text.join(",")
	# @alien_response = textapi.concepts(text: @text)
	# puts @alien_response
	# @alien_hash = []
	# @alien_response[:concepts].each do |concept, value|
	#   surface_forms = value[:surfaceForms].map { |c| c[:string] }.join(', ')
	#   score = value[:surfaceForms].map { |c| c[:score] }
	#   @concept_hash = {surface_forms => score}
	#   @alien_hash.push(@concept_hash)
	# end
	# puts @alien_hash
  	# puts @all_reviews_text
  	respond_to do |format|
		format.json { render json: @all_reviews_array }
		format.js   { render json: @all_reviews_array }
	end
  end

  def search 
		user_search = params[:search]
		@json = ISBN.find_isbn(user_search)
		@returned_books = @json["GoodreadsResponse"]["search"]["results"]["work"]
		# puts @returned_books
  end

  def welcome
  	@img = nil
  end

end

class ChartsController < ApplicationController
  def completed_tasks
    render json: Task.group_by_day(:completed_at).count
  end
end

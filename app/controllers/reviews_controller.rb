
class ReviewsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :xml, :json

  	include ReviewApi
  	include WordCloud
  	include ISBN

	def index
  		@review = Review.new
  		@goodreads_id = session[:isbn]
  		@reviews = Review.where("(isbn IS #{@goodreads_id}) AND (review_text LIKE :query OR title LIKE :query)", 
  		query: "%#{params[:search]}%")
  		@img = session[:img]
  		@title = session[:title]
  		@author = session[:author]
  		@date = session[:date]
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
	# if @goodreads_id.length==10 || @goodreads_id.length==13 && @goodreads_id.numeric?
			puts "That's a nice, clean isbn."
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

		if @added_review.save
		      redirect_to "/" 
		else 
		  	end

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
			@all_reviews_array.push(review.review_text)
			end
  	#EXCLUDE TITLE AND AUTHOR 
  	@exclude_array = [session[:author], session[:title]]
  	@single_exclude_terms = []
  	@exclude_array.each do |this|
  		@split = this.split(" ")
  		@single_exclude_terms.push(@split)
  	end
  	
  	@all_reviews_text = @all_reviews_array.each do |review|
  		@single_exclude_terms.each do |term|
		puts term
		review.gsub(/#{term}/, '')
		end
  	end
  	# puts @all_reviews_text
  	respond_to do |format|
		format.json { render json: @all_reviews_text }
		format.js   { render json: @all_reviews_text }
	end
  end

  def search 
		user_search = params[:search]
		@json = ISBN.find_isbn(user_search)
		@returned_books = @json["GoodreadsResponse"]["search"]["results"]["work"]
		# puts @returned_books
  end

  def welcome

  end
end

class ChartsController < ApplicationController
  def completed_tasks
    render json: Task.group_by_day(:completed_at).count
  end
end

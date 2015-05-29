
class ReviewsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :xml, :json

  	include ReviewApi
  	include WordCloud
  	include ISBN

	def index
  		@review = Review.new
  		@isbn = session[:isbn]
  		@reviews = Review.where("(isbn IS #{@isbn}) AND (review_text LIKE :query OR title LIKE :query)", 
  		query: "%#{params[:search]}%")
  		@img = params[:img]
  		@title = params[:title]
  		@author = params[:author]
  		@reviews = params[:reviews]
  		@date = params[:date]
  		puts @title
  		puts @pub
  		puts @date
  	end
    def show
  	@review = Review.find(params[:id])
  	end

  	def new
  	@review = Review.new
  	end

  	def create
		puts "firing"
		@isbn = params[:choice]
		puts @isbn
		  #get isbn from session if it is blank
		  params[:choice] ||= session[:isbn]
		  #save isbn to session for future requests
		  session[:isbn] = params[:choice]
		session[:img] = params[:img]
		session[:title] = params[:title]

		if @isbn.length==10 || @isbn.length==13 && @isbn.numeric?
			puts "That's a nice, clean isbn."
			api_reviews = ReviewApi::CalledReviews.new
			@gr_reviewsreview_array = api_reviews.gr_reviews(@isbn)
			@amz_review_array = api_reviews.amz_reviews(@isbn)
			@reviews_array = @gr_review_array.push(*@amz_review_array)
			@reviews_array.each_with_index do |this|
					isbn = this[:isbn]
					rating = this[:rating]
					review_text = this[:review_text]
					user = this[:user]		
				@added_review = Review.create(isbn: isbn, 
						title: user, 
						review_text: review_text,
					star_rating: rating)
			end
		else
			puts "That's no good."
			redirect_to "/"
			# get_isbn
		end

		if @added_review.save
		      redirect_to "/" 
		  	end
  	end

  	def star_rating_filter
  		#get star filtered reviews text
	  	@user_cloud_prefs = [stars: params[:stars], count: params[:count], user_excludes: params[:user_excludes]]
  		#pass to wordcounter
		new_count = WordCloud::WordCount.new(@user_cloud_prefs)
		@isbn = session[:isbn]
		@top_terms = new_count.get_reviews_by_stars(@isbn)
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
  	@isbn = session[:isbn]
  	@reviews = Review.where("isbn LIKE '%#{@isbn}%'")
  	puts @reviews
  	@all_reviews_text = []
  	@reviews.each do |review|
			@all_reviews_text.push(review.review_text)
			end
  	respond_to do |format|
		format.json { render json: @all_reviews_text }
		format.js   { render json: @all_reviews_text }
	end
  end

  def search 
		user_search = params[:search]
		@json = ISBN.find_isbn(user_search)
		@returned_books = @json["GoodreadsResponse"]["search"]["results"]["work"]
		puts @returned_books
  end

  def welcome

  end
end

class ChartsController < ApplicationController
  def completed_tasks
    render json: Task.group_by_day(:completed_at).count
  end
end

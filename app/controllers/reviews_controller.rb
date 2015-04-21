
class ReviewsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :xml, :json

  	include ReviewApi
  	include WordCloud
  	include ISBN

	def index
  		@review = Review.new
  		# @isbn = params[:isbn]
  		# puts @isbn
  		@reviews = Review.where(
  		"cast(isbn as text) LIKE :query OR review_text LIKE :query OR title LIKE :query", 
  		query: "%#{params[:isbn]}%")
  		@img = session[:img]
  		@title = session[:title]
  		@pub = session[:pub]
  		@date = session[:date]
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
		  # User.current = params[:choice]
		
		session[:img] = params[:img]
		session[:title] = params[:title]

		if @isbn.length==10 || @isbn.length==13 && @isbn.numeric?
			puts "That's a nice, clean isbn."
			api_reviews = ReviewApi::CalledReviews.new
			@reviews_array = api_reviews.call_reviews(@isbn)
			@reviews_array.each_with_index do |this|
					isbn = this[:isbn]
					title = this[:title]
					review_text = this[:review_text]
					likes = this[:likes]
					shelves = this[:shelves]		
				@added_review = Review.create(isbn: isbn, 
						title: title, 
						review_text: review_text,
						likes: likes,
						shelves: shelves,
					star_rating: rand(0..5))
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
  	# @isbn = session[:isbn]
  	# puts @isbn
  	# @reviews = Review.where("isbn LIKE '%#{@isbn}%'")
  	@reviews = Review.all
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
		@returned_books = ISBN.find_isbn(user_search)
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

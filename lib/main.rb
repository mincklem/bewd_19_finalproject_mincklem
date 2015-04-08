require 'rest-client'
require 'JSON'
require './amazon_reviews'
require 'time'
require './goodreads_reviews'
require './word_count'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './stopwords'

#checking if string is numeric
class String
  def numeric?	
    Float(self) != nil rescue false
  end
end

#get ISBN from user
def get_isbn
	puts "Enter your 10-digit ISBN, dashes are ok:"
	isbn = gets.chomp
	clean_isbn(isbn)
end

#clean isbn and check if valid
def clean_isbn(isbn)
	clean_isbn = isbn.delete("-").delete(" ")
	if clean_isbn.length == 10 && clean_isbn.numeric?
		puts "That's a nice, clean isbn."
		#pass to get Reviews
		get_Reviews(clean_isbn)
	else
		puts
		puts "--------------------------"
		puts "Please validate your ISBN. Make sure it's 10 digits long and contains no letters or special characters:"
		get_isbn
	end
end

#get the reviews, given the clean ISBN
def get_Reviews(clean_isbn)
		# amazon_reviews = Amazon.new
		# amazon_reviews.get_amazon_review(clean_isbn)
		greads_reviews = Getting_Goodreads_Reviews::Greads.new
		greads_reviews.all_greads_reviews(clean_isbn)
end

#beginning application
puts
puts "=================================="
puts
puts "Welcome to the Goodreads reviews tool.  Goodreads' API is cagey - they only return an iframe with the first 300 words of each review, but we want the full text of each  for word counts."
puts 
puts "Steps: get reviews for your ISBN, pull iframe src URL, use it find all the unique review IDs for each review, use those to pull each full review for your book."
puts
puts "It's not the fastest, as some Goodreads reviewers are crazy people - long reviews, gifs, emoji-madness, etc. Pulling the first page for now."
puts
#off we go
get_isbn



require './lib/word_count'
require './lib/stopwords'
require './lib/review_api'
require './lib/shelves_api'
require 'JSON'
require 'rest-client'
require 'jquery-rails'
require 'isbn_finder'


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

end

class String
	def numeric?	
	Float(self) != nil rescue false
	end
end

class User

	def self.current=(isbn)
	@current_user = u
	end

	def self.current
	@current_user
	end

end
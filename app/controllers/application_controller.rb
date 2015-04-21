require './lib/word_count'
require './lib/stopwords'
require './lib/review_api'
require './lib/shelves_api'
require 'json'
require 'rest-client'
require 'jquery-rails'
require 'isbn_finder'


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def after_sign_in_path_for(resource)
    	welcome_path
  	end
end

class String
	def numeric?	
	Float(self) != nil rescue false
	end
end



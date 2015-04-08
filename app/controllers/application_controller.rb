require './lib/word_count'
require './lib/stopwords'
require './lib/review_api'
require 'rest-client'
require 'JSON'
require 'jquery-rails'

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


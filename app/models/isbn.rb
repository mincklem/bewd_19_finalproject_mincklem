class Isbn < ActiveRecord::Base
	has_many :reviews
	has_many :shelves
end

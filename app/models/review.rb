
class Review < ActiveRecord::Base
	belongs_to :user
	serialize :my_lists, Array
	#do validation here --- validates 
	def self.search_for 
	end

	
end

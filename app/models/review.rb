
class Review < ActiveRecord::Base
	belongs_to :user
	#do validation here --- validates 
	def self.search_for 
	end

	
end

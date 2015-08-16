class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  serialize :recent_titles, Array
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

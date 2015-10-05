class User < ActiveRecord::Base
	has_secure_password
	has_many :useringredients
	has_many :ingredients, through: :useringredients
	has_many :userrecipies
	has_many :favorites, through: :userrecipies, :class_name => 'Recipe'
	validates_presence_of :username  
	validates_uniqueness_of :username
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_presence_of :password_digest
end

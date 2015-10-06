class User < ActiveRecord::Base
	has_secure_password
	has_many :useringredients
	has_many :allergens, through: :useringredients, :class_name =>'Ingredient' 
	has_many :userrecipies
	has_many :favorites, through: :userrecipies, :class_name => 'Recipe'
	validates_presence_of :username  
	validates_uniqueness_of :username
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_presence_of :password_digest
	accepts_nested_attributes_for :allergens
end

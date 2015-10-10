class User < ActiveRecord::Base
	has_secure_password
	has_many :useringredients
	has_many :allergens, through: :useringredients, :class_name =>'Ingredient' 
	has_many :userrecipes
	has_many :favorites, through: :userrecipes, :class_name => 'Recipe'
	has_many :contributions, through: :userrecipes, :class_name => 'Recipe'
	has_many :ratings
	validates_presence_of :username  
	validates_uniqueness_of :username
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_presence_of :password_digest
	accepts_nested_attributes_for :allergens
end

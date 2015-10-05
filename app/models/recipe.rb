class Recipe < ActiveRecord::Base
	has_many :userrecipes
	has_many :users, through: :userrecipes
	has_many :recipeingredients
	has_many :recipes, through: :recipeingredients
end

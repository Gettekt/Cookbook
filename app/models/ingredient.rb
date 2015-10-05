class Ingredient < ActiveRecord::Base
	has_many :recipeingredients
	has_many :recipes, through: :recipeingredients
	has_many :useringredients
	has_many :users, through: :useringredients
end

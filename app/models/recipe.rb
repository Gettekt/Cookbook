class Recipe < ActiveRecord::Base
	has_many :userrecipes, :foreign_key => 'contribution_id'
	has_many :users, through: :userrecipes
	has_many :recipeingredients
	has_many :ingredients, through: :recipeingredients
	has_many :recipetags
	has_many :tags, through: :recipetags
end

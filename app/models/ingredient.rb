class Ingredient < ActiveRecord::Base
	has_many :recipeingredients
	has_many :recipes, through: :recipeingredients
	has_many :useringredients, :foreign_key => 'allergen_id'
	has_many :users, through: :useringredients
end

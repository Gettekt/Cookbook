class Useringredient < ActiveRecord::Base
	belongs_to :user
	belongs_to :allergen, :class_name => 'Ingredient'
end
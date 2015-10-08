class Userrecipe < ActiveRecord::Base
	belongs_to :contribution, :class_name => 'Recipe'
	belongs_to :favorite, :class_name => 'Recipe' 
	belongs_to :user 
end 
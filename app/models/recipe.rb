class Recipe < ActiveRecord::Base
	has_many :userrecipes, :foreign_key => 'contribution_id'
	has_many :users, through: :userrecipes
	has_many :recipeingredients
	has_many :ingredients, through: :recipeingredients
	has_many :recipetags
	has_many :tags, through: :recipetags
	has_many :ratings
	has_attached_file :image
	
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end

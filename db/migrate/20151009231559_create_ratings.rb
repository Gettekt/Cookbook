class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :recipe_id
      t.integer :user_id
      t.float :value 
    end
  end
end

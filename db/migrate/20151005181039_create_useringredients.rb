class CreateUseringredients < ActiveRecord::Migration
  def change
    create_table :useringredients do |t|
    	t.integer :user_id
    	t.integer :allergen_id
    	t.timestamps null: false
    end
  end
end

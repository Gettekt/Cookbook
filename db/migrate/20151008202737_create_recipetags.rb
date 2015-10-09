class CreateRecipetags < ActiveRecord::Migration
  def change
    create_table :recipetags do |t|
      t.integer :recipe_id
      t.integer :tag_id
    end
  end
end

class CreateUserrecipes < ActiveRecord::Migration
  def change
    create_table :userrecipes do |t|
    	t.belongs_to :user, :index => true
    	t.belongs_to :contribution, :index => true
    	t.belongs_to :favorite, :index => true 

    	t.timestamps null: false
    end
  end
end

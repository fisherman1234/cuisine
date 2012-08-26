class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :preparation_time
      t.integer :cooking_time
      t.string :selection_id
      t.integer :rating
      t.string :title
      t.string :instructions
      t.string :dish_type
      t.integer :cost
      t.integer :difficulty
      t.timestamps
      t.boolean :is_vegetarian
      t.string :picture_url
      t.integer :marmiton_id
    end
  end
end

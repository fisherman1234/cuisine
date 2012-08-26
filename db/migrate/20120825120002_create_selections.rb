class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :description
      t.string :url
      t.string :type

      t.timestamps
    end
  end
end

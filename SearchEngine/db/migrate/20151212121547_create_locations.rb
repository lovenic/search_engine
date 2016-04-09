class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :position
      t.string :word_area
      t.references :word, index: true, foreign_key: true
      t.references :page, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

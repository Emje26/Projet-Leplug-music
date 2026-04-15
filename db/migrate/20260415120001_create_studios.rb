class CreateStudios < ActiveRecord::Migration[7.1]
  def change
    create_table :studios do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :name, null: false
      t.text    :description
      t.string  :address
      t.string  :city
      t.decimal :price_per_hour, precision: 8, scale: 2
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :rating, precision: 3, scale: 2, default: 0
      t.integer :reviews_count, default: 0
      t.string  :category
      t.jsonb   :equipment, default: []
      t.string  :cover_url

      t.timestamps
    end

    add_index :studios, :city
    add_index :studios, :category
  end
end

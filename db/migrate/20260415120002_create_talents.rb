class CreateTalents < ActiveRecord::Migration[7.1]
  def change
    create_table :talents do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :name, null: false
      t.string  :specialty
      t.jsonb   :genres, default: []
      t.decimal :hourly_rate, precision: 8, scale: 2
      t.text    :description
      t.string  :portfolio_url
      t.string  :city
      t.decimal :rating, precision: 3, scale: 2, default: 0
      t.integer :reviews_count, default: 0
      t.boolean :available, default: true
      t.string  :cover_url

      t.timestamps
    end

    add_index :talents, :specialty
    add_index :talents, :city
  end
end

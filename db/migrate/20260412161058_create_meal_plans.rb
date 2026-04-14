class CreateMealPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :week_start_date
      t.text :plan_data

      t.timestamps
    end
  end
end

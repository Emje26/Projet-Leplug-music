class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bookable, polymorphic: true, null: false
      t.date    :date, null: false
      t.time    :start_time
      t.time    :end_time
      t.decimal :duration_hours, precision: 4, scale: 1
      t.decimal :subtotal,    precision: 8, scale: 2
      t.decimal :service_fee, precision: 8, scale: 2
      t.decimal :total,       precision: 8, scale: 2
      t.string  :status, default: 'pending', null: false

      t.timestamps
    end

    add_index :bookings, :status
  end
end

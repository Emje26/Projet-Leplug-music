# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_04_15_120004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bookable_type", null: false
    t.bigint "bookable_id", null: false
    t.date "date", null: false
    t.time "start_time"
    t.time "end_time"
    t.decimal "duration_hours", precision: 4, scale: 1
    t.decimal "subtotal", precision: 8, scale: 2
    t.decimal "service_fee", precision: 8, scale: 2
    t.decimal "total", precision: 8, scale: 2
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bookable_type", "bookable_id"], name: "index_bookings_on_bookable"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "week_start_date"
    t.text "plan_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meal_plans_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.integer "prep_time"
    t.integer "cook_time"
    t.integer "servings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "calories", comment: "Calories par portion (kcal)"
    t.decimal "proteins", precision: 6, scale: 2, comment: "Protéines en grammes"
    t.decimal "carbs", precision: 6, scale: 2, comment: "Glucides en grammes"
    t.decimal "fats", precision: 6, scale: 2, comment: "Lipides en grammes"
    t.decimal "fiber", precision: 6, scale: 2, comment: "Fibres en grammes"
    t.string "difficulty", default: "facile", comment: "Niveau: facile, moyen, difficile"
    t.string "image_url", comment: "URL de l'image de la recette"
    t.decimal "estimated_cost", precision: 6, scale: 2, comment: "Coût estimé en euros"
    t.string "category", comment: "Catégorie: petit-déjeuner, déjeuner, dîner, snack"
    t.string "cuisine_type", comment: "Type de cuisine: française, italienne, etc."
    t.boolean "is_vegetarian", default: false
    t.boolean "is_vegan", default: false
    t.boolean "is_gluten_free", default: false
    t.text "image_data"
    t.index ["category"], name: "index_recipes_on_category"
    t.index ["difficulty"], name: "index_recipes_on_difficulty"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reviewable_type", null: false
    t.bigint "reviewable_id", null: false
    t.integer "rating", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "studios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "address"
    t.string "city"
    t.decimal "price_per_hour", precision: 8, scale: 2
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.decimal "rating", precision: 3, scale: 2, default: "0.0"
    t.integer "reviews_count", default: 0
    t.string "category"
    t.jsonb "equipment", default: []
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_studios_on_category"
    t.index ["city"], name: "index_studios_on_city"
    t.index ["user_id"], name: "index_studios_on_user_id"
  end

  create_table "talents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "specialty"
    t.jsonb "genres", default: []
    t.decimal "hourly_rate", precision: 8, scale: 2
    t.text "description"
    t.string "portfolio_url"
    t.string "city"
    t.decimal "rating", precision: 3, scale: 2, default: "0.0"
    t.integer "reviews_count", default: 0
    t.boolean "available", default: true
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_talents_on_city"
    t.index ["specialty"], name: "index_talents_on_specialty"
    t.index ["user_id"], name: "index_talents_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer "age"
    t.string "gender"
    t.string "activity_level"
    t.decimal "weekly_budget_max"
    t.integer "max_prep_time_minutes"
    t.text "allergies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.integer "age"
    t.string "physical_activity_profile"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "users"
  add_foreign_key "meal_plans", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "recipes", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "studios", "users"
  add_foreign_key "talents", "users"
  add_foreign_key "user_preferences", "users"
end

# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151009231559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "user_id"
    t.float   "value"
  end

  create_table "recipeingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.string   "amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.string   "directions"
    t.float    "rating"
    t.integer  "serves"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipetags", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "useringredients", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "allergen_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "userrecipes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "contribution_id"
    t.integer  "favorite_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "userrecipes", ["contribution_id"], name: "index_userrecipes_on_contribution_id", using: :btree
  add_index "userrecipes", ["favorite_id"], name: "index_userrecipes_on_favorite_id", using: :btree
  add_index "userrecipes", ["user_id"], name: "index_userrecipes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_20_122128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cloud_payments_public_id"
    t.string "cloud_payments_api_key"
    t.index ["title"], name: "index_accounts_on_title", unique: true
  end

  create_table "machines", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.integer "internal_id", null: false
    t.integer "public_number", null: false
    t.datetime "last_activity_at"
    t.string "location", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_machines_on_account_id"
    t.index ["internal_id"], name: "index_machines_on_internal_id", unique: true
    t.index ["public_number"], name: "index_machines_on_public_number", unique: true
  end

  create_table "payments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "machine_id", null: false
    t.uuid "price_id", null: false
    t.integer "total_price_cents", default: 0, null: false
    t.string "total_price_currency", default: "USD", null: false
    t.string "title", null: false
    t.string "state", default: "new", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["machine_id"], name: "index_payments_on_machine_id"
    t.index ["price_id"], name: "index_payments_on_price_id"
  end

  create_table "prices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "title"], name: "index_prices_on_account_id_and_title", unique: true
    t.index ["account_id"], name: "index_prices_on_account_id"
  end

  add_foreign_key "machines", "accounts"
  add_foreign_key "payments", "machines"
  add_foreign_key "payments", "prices"
  add_foreign_key "prices", "accounts"
end

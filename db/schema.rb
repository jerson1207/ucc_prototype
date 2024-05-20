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

ActiveRecord::Schema[7.1].define(version: 2024_05_20_001956) do
  create_table "inventories", force: :cascade do |t|
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.string "shipment"
    t.date "date_received"
    t.string "inventory_type"
    t.string "state_code"
    t.string "rider_no"
    t.date "coverage_date_from"
    t.date "coverage_date_to"
    t.integer "volume"
    t.string "index_unit"
    t.string "index_date"
    t.string "blank_party_unit"
    t.string "blank_party_date"
    t.string "collateral_unit"
    t.string "collateral_date"
    t.string "special_unit"
    t.string "special_date"
    t.string "tax_lien_unit"
    t.string "tax_lien_date"
    t.string "frame_scanned_unit"
    t.string "frame_scanned_date"
    t.string "mdb_unit"
    t.string "mdb_date"
    t.string "office_product_unit"
    t.string "office_product_date"
    t.string "tat_index"
    t.string "tat_blank_party"
    t.string "tat_collateral"
    t.string "tat_special"
    t.string "tat_tax_lien"
    t.string "tat_mdb"
    t.string "tat_office_product"
    t.string "volume_status"
    t.integer "days_old"
    t.integer "inventory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id"
  end

  create_table "qc_items", force: :cascade do |t|
    t.string "ucc_transmission_date"
    t.string "number_of_filing"
    t.string "no_of_error_critical"
    t.string "no_of_error_non_critcal"
    t.string "quality_score_critical"
    t.string "quality_score_non_critical"
    t.string "base"
    t.string "debtor"
    t.string "collaterals"
    t.string "month_year"
    t.integer "qc_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["qc_id"], name: "index_qc_items_on_qc_id"
  end

  create_table "qcs", force: :cascade do |t|
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "qc_items", "qcs"
end

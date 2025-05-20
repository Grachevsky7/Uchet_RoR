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

ActiveRecord::Schema[7.1].define(version: 2025_05_18_212344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "klients", force: :cascade do |t|
    t.string "name_komp"
    t.string "kontakt_lico"
    t.string "telef_kl"
    t.string "pochta_kl"
    t.string "adres_kl"
    t.boolean "status"
    t.boolean "s_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_zakazs", force: :cascade do |t|
    t.bigint "po_id", null: false
    t.bigint "klient_id", null: false
    t.date "data_zak"
    t.string "stat_zak"
    t.bigint "specialist_id", null: false
    t.date "data_vypoln_zak"
    t.decimal "stoimost_v_god"
    t.integer "srok_arendy"
    t.decimal "stoimost_zak"
    t.string "dok_vypoln_zak_path"
    t.string "chek_opl_zak_path"
    t.boolean "status"
    t.boolean "s_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klient_id"], name: "index_new_zakazs_on_klient_id"
    t.index ["po_id"], name: "index_new_zakazs_on_po_id"
    t.index ["specialist_id"], name: "index_new_zakazs_on_specialist_id"
  end

  create_table "obrashenies", force: :cascade do |t|
    t.bigint "po_id", null: false
    t.bigint "klient_id", null: false
    t.string "tema_obr"
    t.date "data_obr"
    t.string "status_obr"
    t.bigint "specialist_id", null: false
    t.date "data_vypoln_obr"
    t.string "dok_vypoln_obr_path"
    t.boolean "status"
    t.boolean "s_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klient_id"], name: "index_obrashenies_on_klient_id"
    t.index ["po_id"], name: "index_obrashenies_on_po_id"
    t.index ["specialist_id"], name: "index_obrashenies_on_specialist_id"
  end

  create_table "pos", force: :cascade do |t|
    t.string "name_po"
    t.string "vers_po"
    t.date "data_vypuska_po"
    t.decimal "stoimost_v_god_po"
    t.boolean "status"
    t.boolean "s_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specialists", force: :cascade do |t|
    t.string "fio_spec"
    t.string "telef_spec"
    t.string "pochta_spec"
    t.string "dlzhnst_spec"
    t.string "status_spec"
    t.boolean "status"
    t.boolean "s_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "new_zakazs", "klients"
  add_foreign_key "new_zakazs", "pos"
  add_foreign_key "new_zakazs", "specialists"
  add_foreign_key "obrashenies", "klients"
  add_foreign_key "obrashenies", "pos"
  add_foreign_key "obrashenies", "specialists"
end

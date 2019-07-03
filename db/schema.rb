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

ActiveRecord::Schema.define(version: 2019_07_03_122544) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "phone_calls", force: :cascade do |t|
    t.string "number"
    t.string "caller_number"
    t.string "caller_city"
    t.string "caller_province"
    t.string "caller_country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sid"
    t.index ["sid"], name: "index_calls_on_sid"
  end

  create_table "recordings", force: :cascade do |t|
    t.integer "phone_call_id", limit: 8, null: false
    t.string "recording_sid"
    t.string "duration"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone_call_id"], name: "index_recordings_on_call_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "phone_call_id", limit: 8
    t.string "prompt_handle"
    t.string "digits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "recording_id", limit: 8
    t.text "transcription"
    t.index ["phone_call_id", "prompt_handle"], name: "index_responses_on_phone_call_id_and_prompt_handle"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end

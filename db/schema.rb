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

ActiveRecord::Schema.define(version: 2019_06_06_235222) do

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
    t.integer "phone_call_id", null: false
    t.string "recording_sid"
    t.string "duration"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone_call_id"], name: "index_recordings_on_call_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "phone_call_id"
    t.string "question_handle"
    t.string "digits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "recording_id"
    t.index ["phone_call_id", "question_handle"], name: "index_responses_on_phone_call_id_and_question_handle"
  end

  add_foreign_key "recordings", "phone_calls"
end

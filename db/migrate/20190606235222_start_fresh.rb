class StartFresh < ActiveRecord::Migration[6.0]
  def up
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
      t.integer "phone_call_id", null: false, limit: 8
      t.string "recording_sid"
      t.string "duration"
      t.string "url"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["phone_call_id"], name: "index_recordings_on_call_id"
    end

    create_table "responses", force: :cascade do |t|
      t.integer "phone_call_id", limit: 8
      t.string "question_handle"
      t.string "digits"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "recording_id", limit: 8
      t.index ["phone_call_id", "question_handle"], name: "index_responses_on_phone_call_id_and_question_handle"
    end
  end
end

class CreateRecordings < ActiveRecord::Migration[6.0]
  def change
    create_table :recordings do |t|
      t.references :call, null: false, foreign_key: true
      t.string :recording_sid
      t.string :duration
      t.string :url

      t.timestamps
    end
  end
end

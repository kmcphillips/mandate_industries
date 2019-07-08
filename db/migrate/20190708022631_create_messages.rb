class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :sms_conversation_id, null: false, limit: 8
      t.string :sid
      t.text :body
      t.string :status
      t.string :direction

      t.timestamps

      t.index :sms_conversation_id
      t.index :direction
    end
  end
end

class CreateSMSConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_conversations do |t|
      t.string :number
      t.string :tree_name
      t.string :from_number
      t.string :from_city
      t.string :from_province
      t.string :from_country

      t.timestamps
    end
  end
end

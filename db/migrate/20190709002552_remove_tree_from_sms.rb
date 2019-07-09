class RemoveTreeFromSMS < ActiveRecord::Migration[6.0]
  def change
    remove_column :sms_conversations, :tree_name
  end
end

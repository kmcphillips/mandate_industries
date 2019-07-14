class AddDirectionToPhoneCall < ActiveRecord::Migration[6.0]
  def change
    add_column :phone_calls, :direction, :string
    add_index :phone_calls, :direction
  end
end

class AddTreeToPhoneCall < ActiveRecord::Migration[6.0]
  def change
    add_column :phone_calls, :tree_name, :string
  end
end

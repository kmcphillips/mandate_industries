class AddSidToCall < ActiveRecord::Migration[6.0]
  def change
    add_column :calls, :sid, :string
    add_index :calls, :sid
  end
end

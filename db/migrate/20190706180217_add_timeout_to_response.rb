class AddTimeoutToResponse < ActiveRecord::Migration[6.0]
  def change
    add_column :responses, :timeout, :boolean, default: false
  end
end

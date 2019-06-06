class AddRecordingToResponse < ActiveRecord::Migration[6.0]
  def change
    add_column :responses, :recording_id, :integer
  end
end

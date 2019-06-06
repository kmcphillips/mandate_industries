class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.references :call
      t.string :question_handle
      t.string :digits

      t.timestamps

      t.index([:call_id, :question_handle])
    end
  end
end

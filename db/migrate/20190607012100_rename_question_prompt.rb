class RenameQuestionPrompt < ActiveRecord::Migration[6.0]
  def change
    remove_index :responses, ["phone_call_id", "question_handle"]
    rename_column :responses, :question_handle, :prompt_handle
    add_index :responses, ["phone_call_id", "prompt_handle"]
  end
end

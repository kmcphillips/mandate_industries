class CreateCalls < ActiveRecord::Migration[6.0]
  def change
    create_table :calls do |t|
      t.string :number
      t.string :caller_number
      t.string :caller_city
      t.string :caller_province
      t.string :caller_country

      t.timestamps
    end
  end
end

class RenamePhoneCallerToFrom < ActiveRecord::Migration[6.0]
  def change
    rename_column :phone_calls, :caller_number, :from_number
    rename_column :phone_calls, :caller_city, :from_city
    rename_column :phone_calls, :caller_province, :from_province
    rename_column :phone_calls, :caller_country, :from_country
  end
end

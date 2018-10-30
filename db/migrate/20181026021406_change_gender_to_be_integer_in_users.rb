class ChangeGenderToBeIntegerInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :gender, :integer, using: 'gender::integer'
  end
end

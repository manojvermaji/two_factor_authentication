class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :two_factor_authentication, :boolean, :default => true
  end
end

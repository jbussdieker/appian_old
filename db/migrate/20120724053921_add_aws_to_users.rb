class AddAwsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :access_key_id, :string
    add_column :users, :secret_access_key, :string
  end

  def down
    remove_column :users, :access_key_id
    remove_column :users, :secret_access_key
  end
end

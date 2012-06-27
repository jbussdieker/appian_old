class AddKeysUserid < ActiveRecord::Migration
  def up
	add_column :keys, :user_id, :integer
  end

  def down
	remove_column :keys, :user_id
  end
end

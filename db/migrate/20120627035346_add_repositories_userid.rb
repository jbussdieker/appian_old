class AddRepositoriesUserid < ActiveRecord::Migration
  def up
	add_column :repositories, :user_id, :integer
  end

  def down
	remove_column :repositories, :user_id
  end
end

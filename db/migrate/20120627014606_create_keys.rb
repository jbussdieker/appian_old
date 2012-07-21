class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :name
      t.integer :user_id
      t.text :key

      t.timestamps
    end
  end
end

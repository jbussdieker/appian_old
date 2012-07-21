class CreateJobEnvironments < ActiveRecord::Migration
  def change
    create_table :job_environments do |t|
      t.string :name
      t.text :script

      t.timestamps
    end
  end
end

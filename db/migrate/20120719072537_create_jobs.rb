class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :repository_id
      t.string :branch
      t.integer :job_type_id

      t.timestamps
    end
  end
end

class AddJobEnvironmentToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :job_environment_id, :integer
  end
end

class CreateTechnologiesJobsJoinTable < ActiveRecord::Migration
  def change
    create_table :jobs_technologies, id: false do |t|
      t.integer :technology_id
      t.integer :job_id
    end
  end
end

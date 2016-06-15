class AddLocationToJobs < ActiveRecord::Migration
  def change
    add_reference :jobs, :location, index: true, foreign_key: true
  end
end

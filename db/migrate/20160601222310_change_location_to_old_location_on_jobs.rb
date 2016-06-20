class ChangeLocationToOldLocationOnJobs < ActiveRecord::Migration
  def change
    rename_column :jobs, :location, :old_location
  end
end

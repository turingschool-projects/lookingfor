class AddMonocleIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :monocle_id, :integer
  end
end

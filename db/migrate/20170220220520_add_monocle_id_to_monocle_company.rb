class AddMonocleIdToMonocleCompany < ActiveRecord::Migration
  def change
    add_column :monocle_companies, :monocle_id, :integer
  end
end

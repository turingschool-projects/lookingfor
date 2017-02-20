class AddMonocleIdToJob < ActiveRecord::Migration
  def change
    add_reference :jobs, :monocle_company, index: true, foreign_key: true
  end
end

class CreateMonocleCompanies < ActiveRecord::Migration
  def change
    create_table :monocle_companies do |t|
      t.string :name
    end
  end
end

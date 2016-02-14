class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.boolean :remote

      t.timestamps null: false
    end
  end
end

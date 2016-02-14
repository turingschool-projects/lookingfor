class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.text :description
      t.string :url
      t.string :location
      t.date :posted_date
      t.text :raw_technologies, array: true, default: []
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

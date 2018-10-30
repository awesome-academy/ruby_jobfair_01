class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.references :career, foreign_key: true
      t.string :title
      t.integer :salary
      t.string :rank
      t.string :skill
      t.string :language
      t.integer :amount
      t.text :experience
      t.text :description
      t.date :publish_date
      t.date :expiration_date

      t.timestamps
    end
  end
end

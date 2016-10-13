class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.datetime :deadline
      t.integer :priority
      t.datetime :created_at
      t.datetime :updated_at
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end

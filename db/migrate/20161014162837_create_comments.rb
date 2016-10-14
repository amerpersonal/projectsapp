class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.datetime :created_at
      t.datetime :updated_at
      t.belongs_to :task, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end

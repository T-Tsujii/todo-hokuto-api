class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :body, null: false
      t.boolean :is_completed, default: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end

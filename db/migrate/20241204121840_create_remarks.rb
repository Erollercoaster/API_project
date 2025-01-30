class CreateRemarks < ActiveRecord::Migration[7.1]
  def change
    create_table :remarks do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end

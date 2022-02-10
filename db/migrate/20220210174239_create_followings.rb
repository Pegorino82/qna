class CreateFollowings < ActiveRecord::Migration[6.1]
  def change
    create_table :followings do |t|
      t.references :question, foreign_key: true
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

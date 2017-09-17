class CreateMessage < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :message, null: :false
      t.string :user_name, charset: 'ascii'
      t.string :user_id, charset: 'ascii'
      t.integer :count, null: :false
      t.timestamps null: false
    end
  end
end

class CreateMessage < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :message, null: :false
      t.string :tweet_id, charset: 'ascii'
      t.string :screen_name, charset: 'ascii'
      t.string :user_id, charset: 'ascii'
      t.integer :count, null: :false, default: 0
      t.timestamps null: false
    end
  end
end

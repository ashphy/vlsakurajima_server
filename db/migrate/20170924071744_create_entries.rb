class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: false, primary_key: 'uuid' do |t|
      t.string :uuid, null:false, charset: 'ascii'
      t.string :url, charset: 'ascii'
      t.text :content
      t.timestamps
    end
  end
end

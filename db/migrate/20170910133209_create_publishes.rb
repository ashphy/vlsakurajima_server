class CreatePublishes < ActiveRecord::Migration[5.1]
  def change
    create_table :publishes do |t|
      t.text :content
      t.timestamps
    end
  end
end

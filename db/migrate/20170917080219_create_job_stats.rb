class CreateJobStats < ActiveRecord::Migration[5.1]
  def change
    create_table :job_stats do |t|
      t.string :since_id, null: :false, charset: 'ascii'
      t.timestamps null: false
    end
  end
end

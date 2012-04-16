class CreateShiftJobs < ActiveRecord::Migration
  def change
    create_table :shift_jobs do |t|
      t.integer :shift_id
      t.integer :job_id

      t.timestamps
    end
  end
end

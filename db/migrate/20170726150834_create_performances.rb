class CreatePerformances < ActiveRecord::Migration[5.1]
  def change
    create_table(:perfomances) do |t|
      t.column(:student_id, :int)
      t.column(:grade_id, :int)
      t.timestamps
    end
  end
end

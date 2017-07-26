class CreateResult < ActiveRecord::Migration[5.1]
  def change
    create_table(:result) do |t|
      t.column(:subject_id, :int)
      t.column(:student_id, :int)
    end
  end
end

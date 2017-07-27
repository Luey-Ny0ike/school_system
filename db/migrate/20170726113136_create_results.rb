class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table(:results) do |t|
      t.column(:subject_id, :int)
      t.column(:grade_id, :int)
    end
  end
end

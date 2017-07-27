class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table(:assignments) do |t|
      t.column(:level, :int)
      t.column(:stream, :varchar, :limit=>50)
      t.column(:subject, :varchar, :limit=>30)
      t.column(:teacher_id,:int)
      t.column(:content, :string)
      t.column(:due_date, :datetime)
      t.timestamps
    end
  end
end

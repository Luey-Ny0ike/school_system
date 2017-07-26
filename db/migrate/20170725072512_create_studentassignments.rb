class CreateStudentassignments < ActiveRecord::Migration[5.1]
  def change
    create_table(:tracks) do | table|
        table.column(:student_id, :int)
        table.column(:assignment_id, :int)
        table.column(:editing, :boolean)
        table.column(:revision, :boolean)
        table.column(:approved, :boolean)
        table.column(:rejected, :boolean)
        table.timestamp
    end
  end
end

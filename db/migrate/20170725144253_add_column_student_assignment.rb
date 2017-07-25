class AddColumnStudentAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column(:tracks,:file,:bytea)
    add_column(:tracks,:content,:string)
  end
end

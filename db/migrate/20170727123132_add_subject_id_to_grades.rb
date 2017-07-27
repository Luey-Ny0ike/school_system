class AddSubjectIdToGrades < ActiveRecord::Migration[5.1]
  def change
    add_column(:grades, :subject_name, :varchar)
  end
end

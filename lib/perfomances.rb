class Perfomances < ActiveRecord::Base
  belongs_to :students
  belongs_to :grades
  scope :student_grade,->(student_id,grade_id) {where(student_id: student_id, grade_id: grade_id)}
end

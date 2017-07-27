class Perfomance < ActiveRecord::Base
  belongs_to :student
  belongs_to :grade
  scope :student_grade,->(student_id) {where(student_id: student_id)}
end

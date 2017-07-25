class StudentAssignment < ActiveRecord::
    belongs_to :assignment
    belongs_to :student
end
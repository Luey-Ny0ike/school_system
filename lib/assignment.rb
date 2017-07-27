class Assignment < ActiveRecord::Base
    has_many :tracks
    has_many :students, through: :tracks
    #return assignments assigned to this student
    scope :student_assignment,->(level,stream) {where(level: level, stream: stream)}
end

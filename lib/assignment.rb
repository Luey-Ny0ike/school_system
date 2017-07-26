class Assignment < ActiveRecord::Base
    has_many :tracks
    has_many :students, through: :tracks

    scope :student_assignment,->(level,stream) {where(level: level, stream: stream)}
end
class Assignment < ActiveRecord::Base
<<<<<<< HEAD
  has_many :tracks
  has_many :students, through: :tracks

  scope :student_assignment,->(level,stream) {where(level: level, stream: stream)}
=======
    has_many :tracks
    has_many :students, through: :tracks
    #return assignments assigned to this student
    scope :student_assignment,->(level,stream) {where(level: level, stream: stream)}
>>>>>>> 8ee872485fcc67c95945a3e695a346722f933f51
end

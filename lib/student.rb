class Student < ActiveRecord::Base
<<<<<<< HEAD
  has_many :tracks
  has_many :associations
  has_many :assignments, through: :tracks
  has_many :parents, through: :associations
=======
    has_many :tracks
    has_many :associations
    has_many :assignments, through: :tracks
    has_many :parents, through: :associations
    has_many :grades, through: :perfomances
>>>>>>> 8ee872485fcc67c95945a3e695a346722f933f51
end

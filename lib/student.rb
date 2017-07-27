class Student < ActiveRecord::Base
  has_many :tracks
  has_many :associations
  has_many :assignments, through: :tracks
  has_many :parents, through: :associations
  has_many :grades, through: :perfomances
  has_one :fees
end

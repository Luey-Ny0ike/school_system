class Student < ActiveRecord::Base
  has_many :associations
  has_many :parents, through: :associations
end

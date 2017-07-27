class Grade < ActiveRecord::Base
  has_many :results
  has_many :perfomances
  has_many :subjects, through: :results
  has_many :students, through: :perfomances
end

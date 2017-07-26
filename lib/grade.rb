class Grade < ActiveRecord::Base
  has_many :results
  has_many :subjects, through: :results
end

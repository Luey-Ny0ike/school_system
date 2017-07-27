class Subject < ActiveRecord::Base
  has_many :results
  has_many :subjects, through: :results
end

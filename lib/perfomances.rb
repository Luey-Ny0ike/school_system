class Perfomances < ActiveRecord::Base
  belongs_to :students
  belongs_to :grades
end

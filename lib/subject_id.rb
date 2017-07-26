# this is for the subject id I used the name Result  just for naming conventions
class Result <ActiveRecord::Base
  belongs_to :subject
  belongs_to :grade
end

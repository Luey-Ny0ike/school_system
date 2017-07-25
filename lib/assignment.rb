class Assignment < ActiveRecord::Base
    has_many :studentassignments
    has_many :students, through: :studentassignments
end
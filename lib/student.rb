class Student < ActiveRecord::
    has_many :studentassignments
    has_many :assignments, through :studentassignments
end

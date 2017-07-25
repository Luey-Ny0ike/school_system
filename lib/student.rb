class Student < ActiveRecord::
    has_many :studentassignments
    has_many :associations
    has_many :assignments, through :studentassignments
    has_many :parents, through :associations
end

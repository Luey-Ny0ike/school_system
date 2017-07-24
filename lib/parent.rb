class Parent <ActiveRecord::Base
  has_and_belongs_to_many(:students)
  validates(:name, :username, :password, :presence => true)
  validates(:phone, :length => { :maximum => 21})
  before_save(:titlecase_name)

  private

  define_method(:titlecase_name) do
    self.name=(name().titlecase())
  end

end

require("spec_helper")

describe(Parent) do

  it("validates presence of a parent name") do
    parent = Parent.new({:name => "", :username => "", :password => ""})
    expect(parent.save()).to(eq(false))
  end

  it("validates the length of the telephone number inserted to be 11 digits at most")  do
    parent = Parent.new({:name => "Lewis", :phone => "072588888888".*(21)})
    expect(parent.save()).to(eq(false))
  end

  describe('Parent#titlecase_name') do
    it ("converts the name  of a parent to title case") do
      parent = Parent.create({:name => "paul nderitu"})
      expect(parent.name()).to(eq("Paul Nderitu"))
      end
    end
end

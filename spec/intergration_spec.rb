require("spec_helper")

describe('Parent Pages Path', {:type => :feature}) do

   it('allows users to add a new parent to the database') do
     visit('/')
     click_link('Add a New Parent')
     fill_in('distributor_name', :with => 'Paul Nderitu')
     fill_in('phone', :with => '0725888888')
     fill_in('email', :with => 'paulnderitu@moringa.com')
     fill_in('username', :with => 'pau')
     click_button('Add Parent')
     expect(page).to have_content('Paul Nderitu')
   end

   it ("allows uses the admin to view  a list of parents in database") do
     Parent.create({:name => "Paul"})
     visit('/parents')
     expect(page).to have_content("Paul")
   end

   it('allows users to update parents path') do
     Parent.create({:name => 'Paul'})
     visit('/parents')
     click_link('Paul')
     click_link('Update Parent Details')
     fill_in('parent name', :with => 'Paul Nderitu')
     click_button('Update')
     expect(page).to have_content('Paul Nderitu')
   end

   it('allows the administrator to delete a parent from the database') do
       Parent.create({:name => 'Paul'})
       visit('/parents')
       click_link('Paul')
       click_link('Update Parent Details')
       click_button('Delete Paul')
       expect(page).to have_no_content('Paul')
     end
  end

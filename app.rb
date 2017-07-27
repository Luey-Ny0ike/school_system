require('bundler/setup')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

get '/students' do
  @students = Student.all
  erb :students
end

get '/admin/student/new' do
  erb :new_student
end

post '/admin/student/new' do
  @student_name = params.fetch('name')
  @student_level = params.fetch('level').to_i
  @student_stream = params.fetch('stream')
  @student_fee = params.fetch('fee')
  @student_dormitory = params.fetch('dormitory')
  @student_clubs = params.fetch('clubs')
  @new_student = Student.create(name: @student_name, level: @student_level,
                                stream: @student_stream, fee: @student_fee, dormitory: @student_dormitory,
                                clubs: @student_clubs)

  name = params.fetch(:parent_name)
  phone = params[:phone]
  email = params[:email]
  username = params[:username]
  password = params[:password]
  @new_parent = Parent.create(name: name, phone: phone, email: email, username: username, password: password)
  Association.create(student_id: @new_student.id, parent_id: @new_parent.id)
  redirect '/students'
end

get '/student/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @students = Student.all
  @parent_details = Parent.joins(:associations).where(associations: {student_id: @student_details.id})
  @assignments=Assignment.student_assignment(@student_details.level.to_i,@student_details.stream)
  erb :student_detail
end

delete '/student/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @student_details.destroy
  redirect '/students'
end

get('/admin/search') do
  @students = Student.all
  erb (:parent_form)
end



post('/parents') do
  name = params.fetch('parent_name')
  phone = params.fetch('phone')
  email = params.fetch('email')
  username = params.fetch('username')
  password = params.fetch('password')
  student_id = params.fetch('id').to_i
  @student = Student.find(student_id)
  @new_parent = Parent.create(name: name, phone: phone, email: email, username: username, password: password, :student_ids => student_id)
  if   Association.create(student_id: @student.id, parent_id: @new_parent.id)

    redirect('/parents/'.concat(@new_parent.id.to_s))
  else
    erb(:parent_errors)
  end
end


get('/parent/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  erb(:parent)
end

get('/parents') do
  @parents = Parent.all
  erb(:parents)
end

get('/parents/:id/edit') do
  @parent = Parent.find(params.fetch('id').to_i)
  @students =Student.all() -@parent.students()
  erb(:parent_edit)
end

patch('/parents/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  name = params.fetch('distributor_name')
  phone = params[:phone]
  email = params[:email]
  username = params[:username]

  new_student_ids = params[:student_ids]
  remove_student_ids = params[:remove_student_ids]
  if remove_student_ids
    remove_student_ids.each do |id|
      @parent.students.destroy(Student.find(id))
    end
  end

  all_student_ids = []
  @parent.students.each do |student|
    all_student_ids.push(student.id)
  end
  if new_student_ids
    new_student_ids.each do |id|
      all_student_ids.push(id)
    end
  end

  @parent.update(ame: name, phone: phone, email: email, username: username, student_ids: all_student_ids)
  if @parent.save
    redirect('/parents/'.concat(@parent.id.to_s))
  else
    erb(:parent_errors)
  end
end

delete('/parent/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  @parent.destroy
  redirect('/parents')
end

 get ('/students/find/') do
   name = params.fetch('name')
   if @studento=Student.find_by_name(name)
     redirect '/student/'.concat(@studento.id.to_s)
   else
     erb(:parent_errors)
   end
 end

post '/admin/assignment/new' do
   level=params.fetch('level').to_i
   stream=params.fetch('stream')
   subject=params.fetch('subject')
   content=params.fetch('content')
   due_date=params.fetch('due_date')
   Assignment.create(level: level, stream: stream, subject: subject, due_date: due_date)
   redirect 'admin/assignment'
end

get '/students/:id/assignment/:assignment_id' do
  @assignment=Assignment.find(params.fetch('assignment_id').to_i)
  @student=Student.find(params.fetch('id').to_i)
  erb :assignment_detail
end

post '/students/:id/assignment/:assignment_id' do
  @student_id=params.fetch('id').to_i
  @assignment_id=params.fetch('assignment_id').to_i
  content=params.fetch('content')
  Track.create(student_id: @student_id, assignment_id: @assignment_id, editing: FALSE, revision: FALSE, approved: FALSE, rejected: FALSE,content:content,under_review: TRUE)
  redirect '/students/'.concat(@student_id.to_s)
end


get ('/parents/find/') do
  username = params.fetch('username')
  password = params.fetch('password')

  if @parento = Parent.find_by(username: username, password: password)
    redirect '/parent/'.concat(@parento.id.to_s)
  else
    erb(:parent_errors)
  end
end

get '/admin' do
  erb(:admin)
end

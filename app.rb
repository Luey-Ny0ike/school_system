require('bundler/setup')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def teacher_assigned
  Assignment.where(level: 1, stream: "East", teacher_id: 1)
end
get('/') do
  erb(:index)
end

get '/students' do
  @students = Student.all
  erb :students
end

post '/student/new' do
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

get '/students/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @students = Student.all
  @parent_details = Parent.joins(:associations).where(associations: {student_id: @student_details.id})
  @assignments=Assignment.student_assignment(@student_details.level.to_i,@student_details.stream)
  erb :student_detail
end

delete '/students/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @student_details.destroy
  redirect '/students'
end

get('/parents/new') do
  erb(:parent_form)
end

post('/parents') do
  name = params.fetch(:parent_name)
  phone = params[:phone]
  email = params[:email]
  username = params[:username]
  password = params[:password]
  @parent = Parent.create(name: name, phone: phone, email: email, username: username, password: password)
  if @parent.save
    redirect('/parents/'.concat(@parent.id.to_s))
  else
    erb(:parent_errors)
  end
end

get('/parents/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  erb(:parent)
end

get('/parents') do
  @parents = Parent.all
  erb(:parents)
end

get('/parents/:id/edit') do
  @parent = Parent.find(params.fetch('id').to_i)

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

  @parent.update(ame: name, phone: phone, email: email, username: username, brand_ids: all_brand_ids)
  if @parent.save
    redirect('/parents/'.concat(@parent.id.to_s))
  else
    erb(:parent_errors)
  end
end

delete('/parents/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  @parent.destroy
  redirect('/parents')
end

#new assignment
get '/admin/assignment' do
  erb :new_assignment
end

post '/admin/assignment/new' do
  level=params.fetch('level').to_i
  stream=params.fetch('stream')
  subject=params.fetch('subject')
  content=params.fetch('content')
  due_date=params.fetch('due_date')
  teacher_id=params.fetch('teacher_id').to_i
  Assignment.create(level: level,stream: stream, subject: subject, content: content, due_date: due_date, teacher_id: teacher_id)
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


#show teachers
get '/admin/teachers' do
  erb :teachers
end

#teacher portal
get '/admin/teacher/:id' do
  @teacher_id=params.fetch('id').to_i
  @assigned_tasks=Assignment.where(teacher_id: params.fetch('id').to_i)
  erb :teacher_detail
end

get '/admin/teacher/0/assignment/:assignment_id' do
  @assignment=Assignment.find_by(id:params.fetch('assignment_id').to_i)
  @students=Student.joins(:tracks).where(tracks:{assignment_id: params.fetch('assignment_id').to_i})
  erb :teacher_assignment_details
end

get '/admin/teacher/0/assignment/:assignment_id/student/:student_id' do
  @student=Student.find_by(id: params.fetch('student_id').to_i)
  @submission=Track.find_by(student_id: params.fetch('student_id').to_i, assignment_id: params.fetch('assignment_id').to_i)
  @assignment=Assignment.find(params.fetch('assignment_id').to_i)
  erb :assignment_review
end

patch '/assignment_review' do
  assignment_id=params.fetch('assignment_id').to_i
  student_id=params.fetch('student_id').to_i
  under_review=false
  rejected=params[:rejected]=='on' ? true : false
  approved=params[:approved]=='on' ? true : false
  revision=params[:revision]=='on' ? true : false
  track=Track.find_by(student_id: student_id, assignment_id: assignment_id)
  track.update(revision: revision, approved: approved, rejected: rejected, under_review: under_review)
  redirect '/admin/teacher/0/assignment/'.concat(assignment_id.to_s).concat("/student/").concat(student_id.to_s)
end

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

get '/students/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @students = Student.all
  @grades = Grade.all
  @parent_details = Parent.joins(:associations).where(associations: { student_id: @student_details.id })
  @assignments = Assignment.student_assignment(@student_details.level.to_i, @student_details.stream)
  @grades = Grade.student_grade(@student_details.id.to_i, @grades.id.to_i)
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

# new assignment
get '/admin/assignment' do
  erb :new_assignment
end

post '/admin/assignment/new' do
  level = params.fetch('level').to_i
  stream = params.fetch('stream')
  subject = params.fetch('subject')
  content = params.fetch('content')
  due_date = params.fetch('due_date')
  Assignment.create(level: level, stream: stream, subject: subject, due_date: due_date)
  redirect 'admin/assignment'
end

get '/students/:id/assignment/:assignment_id' do
  @assignment = Assignment.find(params.fetch('assignment_id').to_i)
  @student = Student.find(params.fetch('id').to_i)
  erb :assignment_detail
end

post '/students/:id/assignment/:assignment_id' do
  @student_id = params.fetch('id').to_i
  @assignment_id = params.fetch('assignment_id').to_i
  content = params.fetch('content')
  Track.create(student_id: @student_id, assignment_id: @assignment_id, editing: FALSE, revision: FALSE, approved: FALSE, rejected: FALSE, content: content, under_review: TRUE)
  redirect '/students/'.concat(@student_id.to_s)
end

# FOR GRADES
get '/admin/subjects' do
  @subjects = Subject.all
  erb :subjects
end

post '/admin/subjects/new' do
  subject = params.fetch('subject')
  @new_subject = Subject.create(name: subject)
  redirect '/admin/subjects'
end

get '/admin/grades' do
  @grades = Grade.all
  erb :grades
end

get '/admin/grade/new' do
  @allstudents = Student.all
  @allsubjects = Subject.all
  erb :new_grade
end

post '/admin/grade/new' do
  cat1 = params.fetch('cat1')
  cat2 = params.fetch('cat2')
  cat3 = params.fetch('cat3')
  total = params.fetch('total')
  grade = params.fetch('grade')
  position = params.fetch('position')
  comments = params.fetch('comments')
  subject_id = params.fetch('select')
  student = params.fetch('student')
  @new_grade = Grade.create(cat1: cat1, cat2: cat2, cat3: cat3, total: total, grade: grade,
                            position: position, comments: comments)
  Result.create(subject_id: subject_id, grade_id: @new_grade.id)
  Perfomances.create(student_id: student, grade_id: @new_grade.id)
  redirect '/admin/grade/new'
end

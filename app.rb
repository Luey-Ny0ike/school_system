require('bundler/setup')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

# enable :sessions


# def check_login(username, password)
#   check=nil
#   parent=Parent.find_by(username: username)
#   if parent.password==password
#     sessions[:username]=username
#     check=true
#   else
#     check=false
#   end
#   check
# end
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
  @grades = Grade.all
  @parent_details = Parent.joins(:associations).where(associations: { student_id: @student_details.id })
  @fees = Fee.all()
  @assignments=Assignment.joins(:tracks).where(tracks:{student_id: params.fetch('id').to_i})
  # @assignments = Assignment.student_assignment(@student_details.level.to_i, @student_details.stream)
    @perfomances = Grade.joins(:perfomances).where(perfomances:{student_id: params.fetch('id').to_i})
  erb :student_detail
end

delete '/student/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @student_details.destroy
  redirect '/students'
end

get('/admin/search') do
  @students = Student.all
  erb :parent_form
end

post('/parents') do
  name = params.fetch('parent_name')
  phone = params.fetch('phone')
  email = params.fetch('email')
  username = params.fetch('username')
  password = params.fetch('password')
  student_id = params.fetch('id').to_i
  @student = Student.find(student_id)
  @new_parent = Parent.create(name: name, phone: phone, email: email, username: username, password: password, student_ids: student_id)
  if Association.create(student_id: @student.id, parent_id: @new_parent.id)

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
  @students = Student.all - @parent.students
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

# new assignment
get '/admin/assignment' do
  erb :new_assignment
end

 get ('/students/find/') do
   name = params.fetch('name')
   if @studento=Student.find_by_name(name)
     redirect '/student/'.concat(@studento.id.to_s)
   else
     erb(:parent_errors)
   end
 end

post '/admin/teacher/:teacher_id/assignment/new' do
  level = params.fetch('level').to_i
  stream = params.fetch('stream')
  subject = params.fetch('subject')
  content = params.fetch('content')
  due_date = params.fetch('due_date')
  teacher_id = params.fetch('teacher_id').to_i
  Assignment.create(level: level, stream: stream, subject: subject, content: content, due_date: due_date, teacher_id: teacher_id)
  redirect 'admin/teacher/'.concat(teacher_id.to_s)
end

get ('/students/find/') do
  name = params.fetch('name')
  if @studento = Student.find_by_name(name)
    erb(:home)
  else
    erb(:parent_errors)
  end
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

# show teachers
get '/admin/teachers' do
  erb :teachers
end

# teacher portal
get '/admin/teacher/:id' do
  @teacher_id = params.fetch('id').to_i
  @assigned_tasks = Assignment.where(teacher_id: params.fetch('id').to_i)
  erb :teacher_detail
end

get '/admin/teacher/:teacher_id/assignment/:assignment_id' do
  @assignment = Assignment.find_by(id: params.fetch('assignment_id').to_i)
  @teacher_id = params.fetch('teacher_id').to_i
  @students = Student.where(level: @assignment.id, stream: @assignment.stream)
  erb :teacher_assignment_details
end

get '/admin/teacher/:teacher_id/assignment/:assignment_id/student/:student_id' do
  @student = Student.find_by(id: params.fetch('student_id').to_i)
  @submission = Track.find_by(student_id: params.fetch('student_id').to_i, assignment_id: params.fetch('assignment_id').to_i)
  @assignment = Assignment.find(params.fetch('assignment_id').to_i)
  erb :assignment_review
end

patch '/assignment_review' do
  assignment_id = params.fetch('assignment_id').to_i
  student_id = params.fetch('student_id').to_i
  under_review = false
  rejected = params[:rejected] == 'on' ? true : false
  approved = params[:approved] == 'on' ? true : false
  revision = params[:revision] == 'on' ? true : false
  track = Track.find_by(student_id: student_id, assignment_id: assignment_id)
  track.update(revision: revision, approved: approved, rejected: rejected, under_review: under_review)
  redirect '/admin/teacher/0/assignment/'.concat(assignment_id.to_s).concat('/student/').concat(student_id.to_s)
end

# rout to add new assignment as teacher
get '/admin/teacher/:teacher_id/new_assignment' do
  @teacher_id = params.fetch('teacher_id').to_i
  erb :new_assignment
end
get '/bursar' do
  @students = Student.all()
  erb :bursar
end
get '/bursar/student/:id/fees' do
  @students = Student.all()
    @student = Student.find(params.fetch('id').to_i)
  erb(:student_fees)
end

post '/fees' do
  amount_paid = params.fetch("amount_paid")
  student_id = params.fetch("student_id").to_i()
  due_date = params.fetch("due_date")
  @fees = Fee.create(student_id: student_id, due_date:due_date, amount_paid: amount_paid)
  redirect '/students/'.concat(student_id.to_s)
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
  subject = params.fetch('subject')
  student = params.fetch('student')
  @new_grade = Grade.create(cat1: cat1, cat2: cat2, cat3: cat3, total: total, grade: grade,
                            position: position, comments: comments, subject_name: subject)
  Perfomance.create(student_id: student, grade_id: @new_grade.id)
  redirect '/admin/grade/new'
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

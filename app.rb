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

post '/student/new' do
  @student_name = params.fetch('name')
  @student_level = params.fetch('level')
  @student_stream = params.fetch('stream')
  @student_fee = params.fetch('fee')
  @student_dormitory = params.fetch('dormitory')
  @student_clubs = params.fetch('clubs')
  Student.create(name: @student_name, level: @student_level,
                 stream: @student_stream, fee: @student_fee, dormitory: @student_dormitory,
                 clubs: @student_clubs)
  redirect '/students'
end

get '/students/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @students = Student.all
  erb :student_detail
end

delete '/students/:id' do
  @student_details = Student.find(params.fetch('id').to_i)
  @student_details.destroy
  redirect '/students'
end

get('/parents/new') do
  @students = Student.all
  erb(:parent_form)
end

post('/parents') do
  name = params.fetch(:name)
  phone = params[:phone]
  email = params[:email]
  username = params[:username]
  password = params[:password]
  student_ids = params[:student_ids]
  @parent = Parent.create(name: name, phone: phone, email: email, username: username, password: password, :student_ids => student_ids)
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

delete('/parents/:id') do
  @parent = Parent.find(params.fetch('id').to_i)
  @parent.destroy
  redirect('/parents')
end

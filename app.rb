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


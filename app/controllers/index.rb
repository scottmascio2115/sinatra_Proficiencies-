get '/' do
  if session[:id]
    @user = User.find(session[:id])
    @users = User.all
    erb :index
  else
    @users = User.all
    erb :index
  end

end

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

get '/profile_page/:id' do
  if session[:id]
    @user = User.find(params[:id])
    erb :profile_page
  else
    redirect to ('/')
  end
end

get '/logout' do
  session.clear

  redirect to ('/')
end


post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:id].to_i
  session.clear
  200
end

post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:id] = @user.id
    redirect "/profile_page/#{@user.id}"
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end

post '/create_skill/:id' do 
  if session[:id]
    @skill = Skill.create(name: params[:name], context: params[:context])
    @user = User.find(params[:id])
    @proficency = Proficiency.create(experience: params[:experience], user_id: @user.id, skill_id: @skill.id)
    @user.proficiencies << @proficency
    @user.save
    redirect to ("/profile_page/#{@user.id}")
  else
    redirect to ('/')
  end
end

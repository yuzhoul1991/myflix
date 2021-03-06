def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(user=nil)
  user = Fabricate(:user) unless user
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def sign_out
  visit sign_out_path
end

def add_video_to_queue(video)
  visit home_path
  click_on_home_page_video video
  click_link '+ My Queue'
end

def click_on_home_page_video(video)
  find("a[href='/videos/#{video.id}']").click
end

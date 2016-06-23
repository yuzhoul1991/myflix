require 'spec_helper'

feature 'User resets password' do
  let(:user) { Fabricate(:user, password: 'old password') }
  scenario 'user successfully resets password' do
    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in "Email Address", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link("Reset My Password")

    fill_in "New Password", with: "new password"
    click_button "Reset Password"

    fill_in "Email Address", with: user.email
    fill_in "Password", with: "new password"
    click_button "Sign in"

    expect(page).to have_content("Welcome, #{user.fullname}")

    clear_email
  end
end

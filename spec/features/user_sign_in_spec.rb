require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and passworkd" do
    user = Fabricate(:user)
    sign_in user
    expect(page).to have_content(user.fullname)
  end
end

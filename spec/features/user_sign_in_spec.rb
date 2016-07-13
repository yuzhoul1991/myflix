require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and passworkd" do
    user = Fabricate(:user)
    sign_in user
    expect(page).to have_content(user.fullname)
  end

  scenario "with valid email and passworkd" do
    user = Fabricate(:user, active: false)
    sign_in user
    expect(page).not_to have_content(user.fullname)
    expect(page).to have_content('Your account has been suspended, please contact customer service.')
  end
end

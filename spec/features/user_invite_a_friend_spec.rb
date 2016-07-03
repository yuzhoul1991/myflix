require 'spec_helper'

feature 'User invites a friend' do
  let(:user) { Fabricate(:user) }
  let(:invitee) { Fabricate.attributes_for(:user) }
  scenario 'user successfully invites friend and invitation is accepted', { js: true, vcr: true } do
    sign_in user
    send_invitation
    sign_out
    accept_invitation
    invitee_should_follow_inviter
    inviter_should_follow_invitee
    clear_email
  end

  def invitee_should_follow_inviter
    sign_in User.new(invitee)
    click_link 'People'
    expect(page).to have_content user.fullname
    sign_out
  end

  def inviter_should_follow_invitee
    sign_in user
    click_link 'People'
    expect(page).to have_content invitee[:fullname]
    sign_out
  end

  def send_invitation
    visit new_invitation_path
    fill_in "Friend's Name", with: invitee[:fullname]
    fill_in "Friend's Email Address", with: invitee[:email]
    fill_in "Message", with: 'Please join this app'
    click_button "Send Invitation"
  end

  def accept_invitation
    open_email invitee[:email]
    current_email.click_link 'Join MyFlix Now'

    fill_in "Password", with: invitee[:password]
    fill_in "Full Name", with: invitee[:fullname]
    fill_in "Credit Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    select '12 - December', from: 'date_month'
    select '2020', from: 'date_year'
    click_button "Sign Up"
    sleep 5
    expect(page).to have_content 'Sign in'
  end
end

require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  background do
    visit register_path
  end
  let(:valid_user) { Fabricate.attributes_for(:user) }
  let(:invalid_user) { Fabricate.attributes_for(:user, email: nil) }
  let(:good_card) {
    {
      :card_number => '4242424242424242',
      :cvc => '123',
      :exp_year => 1.year.from_now.year,
      :exp_month => 1.month.from_now.month.to_s + ' - ' + Date::MONTHNAMES[1.month.from_now.month]
    }
  }
  let(:invalid_card) {
    good_card.merge(card_number: '123')
  }
  let(:declined_card) {
    good_card.merge(card_number: '4000000000000002')
  }
  scenario "with valid user info and valid card" do
    fill_in_user_info valid_user
    fill_in_credit_card good_card
    click_button 'Sign Up'
    expect(page).to have_content('You have successfully registered')
  end
  scenario "with valid user info and invalid card" do
    fill_in_user_info valid_user
    fill_in_credit_card invalid_card
    click_button 'Sign Up'
    expect(page).to have_content('The card number is not a valid credit card number.')
  end
  scenario "with valid user info and declined card" do
    fill_in_user_info valid_user
    fill_in_credit_card declined_card
    click_button 'Sign Up'
    expect(page).to have_content('Your card was declined.')
  end
  scenario "with invalid user info and valid card" do
    fill_in_user_info invalid_user
    fill_in_credit_card good_card
    click_button 'Sign Up'
    expect(page).to have_content('Invalid user information, please correct and try again.')
  end
  scenario "with invalid user info and invalid card" do
    fill_in_user_info invalid_user
    fill_in_credit_card invalid_card
    click_button 'Sign Up'
    expect(page).to have_content('The card number is not a valid credit card number.')
  end
  scenario "with invalid user info and declined card" do
    fill_in_user_info invalid_user
    fill_in_credit_card declined_card
    click_button 'Sign Up'
    expect(page).to have_content('Invalid user information, please correct and try again.')
  end

  def fill_in_user_info(user)
    fill_in 'Email Address', with: user[:email]
    fill_in 'Password', with: user[:password]
    fill_in 'Full Name', with: user[:fullname]
  end

  def fill_in_credit_card(card)
    fill_in 'Credit Card Number', with: card[:card_number]
    fill_in 'Security Code', with: card[:cvc]
    select card[:exp_month], from: 'date_month'
    select card[:exp_year], from: 'date_year'
  end
end

require 'spec_helper'

feature 'Admin sees payment history' do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let!(:payment) { Fabricate(:payment, user: user) }
  scenario 'admin can see payment history' do
    sign_in admin
    visit admin_payments_path
    expect(page).to have_content(payment.amount/100.0)
    expect(page).to have_content(user.fullname)
    expect(page).to have_content(user.email)
  end
  scenario 'regular user cannot see payment history' do
    sign_in user
    visit admin_payments_path
    expect(page).not_to have_content(payment.amount/100.0)
    expect(page).not_to have_content(user.email)
    expect(page).to have_content('You do not have admin access')

  end
end

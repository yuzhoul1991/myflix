require 'spec_helper'

feature 'user following' do
  let(:follower) { Fabricate(:user) }
  let(:leader) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }
  let(:video) { Fabricate(:video, category: category) }
  let!(:review) { Fabricate(:review, user: leader, video: video) }
  scenario 'user follows and unfollow other users' do
    sign_in
    click_on_home_page_video video

    click_link leader.fullname
    click_link 'Follow'
    expect(page).to have_content(leader.fullname)

    unfollow leader
    expect(page).not_to have_content(leader.fullname)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end

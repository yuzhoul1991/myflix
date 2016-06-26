require 'spec_helper'

feature 'admin adds new video' do
  let(:admin) { Fabricate(:admin) }
  let(:category) { Fabricate(:category) }
  let!(:new_video) { Fabricate.attributes_for(:video, category: category) }
  scenario 'Admin successfully add a new video' do
    sign_in admin
    visit new_admin_video_path

    fill_in 'Title', with: new_video[:title]
    select Category.find(new_video[:category_id]).name, from: 'Category'
    fill_in 'Description', with: new_video[:description]

    attach_file "Large cover", 'spec/support/uploads/monk_large.jpg'
    attach_file "Small cover", 'spec/support/uploads/monk.jpg'

    fill_in 'Video URL', with: 'http://www.example.com/my_video.mp4'
    click_button 'Add Video'

    sign_out
    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end

end

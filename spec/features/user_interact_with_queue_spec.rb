require 'spec_helper'

feature 'Users interact with the queue' do
  let(:category) { Fabricate(:category) }
  let!(:video1) { Fabricate(:video, category: category) }
  let!(:video2) { Fabricate(:video, category: category) }
  let!(:video3) { Fabricate(:video, category: category) }
  scenario "user adds and reorders videos in the queue" do
    sign_in

    find("a[href='/videos/#{video1.id}']").click
    expect(page).to have_content(video1.title)

    click_link '+ My Queue'
    expect(page).to have_content(video1.title)

    verify_cannot_add_to_queue video1

    add_video_to_queue video2
    add_video_to_queue video3

    set_video_position video3, 2
    set_video_position video2, 1
    set_video_position video1, 3

    click_button 'Update Instance Queue'

    expect_video_position video1, 3
    expect_video_position video2, 1
    expect_video_position video3, 2
  end

  def verify_cannot_add_to_queue(video)
    visit video_path(video)
    expect(page).not_to have_content('+ My Queue')
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link '+ My Queue'
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end
end

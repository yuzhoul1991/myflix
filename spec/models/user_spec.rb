require 'spec_helper'

describe User do
  it { should have_many(:reviews)}
  it { should have_many(:queue_items).order('position')}
  it { should validate_presence_of(:email)}
  it { should validate_uniqueness_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:fullname)}
  it { should have_secure_password }

  describe '#video_in_queue?' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    it 'returns true when user has the video in the queue' do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_in_queue?(video)).to be_truthy
    end
    it 'results false when user does not have the video in the queue' do
      expect(user.video_in_queue?(video)).to be_falsey
    end
  end
end

require 'spec_helper'

describe User do
  it { should have_many(:reviews).order("created_at desc")}
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

  describe '#following?' do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    it 'returns true if the user has a following_relationships with the other user' do
      Fabricate(:relationship, leader: leader, follower: follower)
      expect(follower.following?(leader)).to be_truthy
    end
    it 'returns false if the user does not have a following_relationships with the other' do
      expect(follower.following?(leader)).to be_falsey
    end
    it 'returns true if the other user is self' do
      expect(follower.following?(follower)).to be_truthy
    end
  end

  describe '#follow' do
    let(:user) { Fabricate(:user) }
    let(:another_user) { Fabricate(:user) }
    it 'makes user follow the other user' do
      user.follow another_user
      expect(user.following?(another_user)).to be_truthy
    end
    it 'does not allow user to follow itself' do
      user.follow user
      expect(user.following_relationships).to be_empty
    end
  end

  it_behaves_like 'generates token' do
    let(:object) { Fabricate(:user) }
  end
end

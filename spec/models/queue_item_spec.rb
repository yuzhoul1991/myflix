require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  let(:user) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }
  let(:video) { Fabricate(:video, category: category) }
  let(:queue_item) { Fabricate(:queue_item, user: user, video: video)}
  describe "#video_title" do
    it 'returns the title of the video associated with the queue_item' do
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it 'returns nil when review is not present on the video associated with the queue_item' do
      expect(queue_item.video_rating).to be_nil
    end
    it 'returns the rating of the review the user made on the video' do
      review = Fabricate(:review, user: user, video: video)
      expect(queue_item.video_rating).to eq(review.rating)
    end
  end

  describe "#video_category_name" do
    it 'returns the category name of the video' do
      expect(queue_item.video_category_name).to eq(video.category.name)
    end
  end
end

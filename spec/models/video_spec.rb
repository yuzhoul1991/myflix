require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should have_many(:reviews).order("created_at desc")}
  it {should have_many(:queue_items)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe "search_by_title" do
    let(:futurama) { Fabricate(:video, title: 'futurama', created_at: 1.day.ago ) }
    let(:back_to_future) { Fabricate(:video, title: 'back to future') }
    it "returns empty array if no match" do
      expect(Video.search_by_title("crap")).to eq([])
    end
    it "returns array of one video for an exact match" do
      expect(Video.search_by_title("futurama")).to eq([futurama])
    end
    it "returns array of one video for partial match" do
      expect(Video.search_by_title("rama")).to eq([futurama])
    end
    it "returns array of all matches ordered by created_at" do
        expect(Video.search_by_title("futur")).to eq([back_to_future, futurama])
    end
    it "returns empty array when search an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end
  end
  describe "get_average_rating" do
    let (:video) { Fabricate(:video) }
    it 'returns the average rating' do
      total = 0.0
      10.times do
        review = Fabricate(:review)
        total += review.rating
        video.reviews << review
      end
      expect(Video.get_average_rating(video.title)).to eq(total/10.round(1))
    end
    it 'returns 0.0 if no review for the video' do
      expect(Video.get_average_rating(video.title)).to eq(0.0)
    end
  end
end

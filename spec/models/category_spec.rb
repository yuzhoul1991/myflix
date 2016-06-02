require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:name)}

  describe "#recent_videos" do
    let(:comidies) { Fabricate(:category) }
    let!(:futurama) { Fabricate(:video, created_at: 1.day.ago, category: comidies) }
    let!(:back_to_future) { Fabricate(:video, category: comidies) }

    it "returns the vidoes in reverse chronical order by created_at" do
      expect(comidies.recent_videos).to eq([back_to_future, futurama])
    end
    it "returns all the videos if there are less than 6 videos" do
      expect(comidies.recent_videos.count).to eq(2)
    end
    it "returns only 6 vidoes if there are more than 6 vidoes in the cateogry" do
      7.times do
        comidies.videos << Fabricate(:video)
      end
      expect(comidies.recent_videos.count).to eq(6)
    end
    it "returns the most recent 6 videos" do
      6.times do
        comidies.videos << Fabricate(:video)
      end
      old_video = futurama
      expect(comidies.recent_videos).not_to include(old_video)
    end
    it "returns an empty array if the category does not have any videos" do
      Video.destroy_all
      expect(comidies.recent_videos).to eq([])
    end
  end
end

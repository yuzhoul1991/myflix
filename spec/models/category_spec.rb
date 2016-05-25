require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns the vidoes in reverse chronical order by created_at" do
      comidies = Category.create(name: 'comedies')
      futurama = Video.create(title: "futurama", description: "futurama description", created_at: 1.day.ago, category: comidies)
      back_to_future = Video.create(title: "back to future", description: "time travle", category: comidies)
      #comidies.videos += [futurama, back_to_future]
      expect(comidies.recent_videos).to eq([back_to_future, futurama])
    end

    it "returns all the videos if there are less than 6 videos" do
      comidies = Category.create(name: 'comedies')
      futurama = Video.create(title: "futurama", description: "futurama description", created_at: 1.day.ago)
      back_to_future = Video.create(title: "back to future", description: "time travle")
      comidies.videos += [futurama, back_to_future]
      expect(comidies.recent_videos.count).to eq(2)
    end

    it "returns only 6 vidoes if there are more than 6 vidoes in the cateogry" do
      comidies = Category.create(name: 'comedies')
      7.times do
        comidies.videos << Video.create(title: "futurama", description: "futurama description", created_at: 1.day.ago)
      end
      expect(comidies.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comidies = Category.create(name: 'comedies')
      6.times do
        comidies.videos << Video.create(title: "futurama", description: "futurama description")
      end
      old_video = Video.create(title: "old video", description: "old video", category: comidies, created_at: 1.day.ago)
      expect(comidies.recent_videos).not_to include(old_video)
    end

    it "returns an empty array if the category does not have any videos" do
      comidies = Category.create(name: 'comedies')
      expect(comidies.recent_videos).to eq([])
    end
  end
end

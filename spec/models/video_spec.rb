require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe "search_by_title" do
    it "returns empty array if no match" do
      futurama = Video.create(title: "futurama", description: "futurama description")
      back_to_future = Video.create(title: "back to future", description: "time travle")
      expect(Video.search_by_title("crap")).to eq([])
    end
    it "returns array of one video for an exact match" do
      futurama = Video.create(title: "futurama", description: "futurama description")
      back_to_future = Video.create(title: "back to future", description: "time travle")
      expect(Video.search_by_title("futurama")).to eq([futurama])
    end

    it "returns array of one video for partial match" do
      futurama = Video.create(title: "futurama", description: "futurama description")
      back_to_future = Video.create(title: "back to future", description: "time travle")
      expect(Video.search_by_title("rama")).to eq([futurama])
    end

    it "returns array of all matches ordered by created_at" do
      futurama = Video.create(title: "futurama", description: "futurama description")
      back_to_future = Video.create(title: "back to future", description: "time travle")
      expect(Video.search_by_title("futur")).to eq([back_to_future, futurama])
    end

    it "returns empty array when search an empty string" do
      futurama = Video.create(title: "futurama", description: "futurama description")
      back_to_future = Video.create(title: "back to future", description: "time travle")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end

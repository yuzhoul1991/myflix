class Category < ActiveRecord::Base
  has_many :videos, -> { order "created_at desc" }

  validates_presence_of :name

  def recent_videos
    #videos.order("created_at desc").first(6)
    videos.first(6)
  end
end

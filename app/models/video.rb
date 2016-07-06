class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at desc" }
  has_many :queue_items
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%").order("created_at DESC")
  end
end

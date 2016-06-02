class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video

  def video_rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review ? review.rating : nil
  end

  def video_category_name
    video.category.name
  end
end

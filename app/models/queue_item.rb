class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, numericality: { only_integer: true, greater_than: 0 }

  delegate :title, to: :video, prefix: :video

  def video_rating
    review.rating if review
  end

  def video_rating=(new_rating)
    if review
      # use update_attribute to skip validation
      review.update_attribute('rating', new_rating)
    else
      new_review = Review.create(user: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  def video_category_name
    video.category.name
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end

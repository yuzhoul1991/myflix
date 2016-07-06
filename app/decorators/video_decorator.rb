class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    return 0.0 if object.reviews.empty?
    avg = object.reviews.inject(0.0){ |sum, review| sum + review.rating} / object.reviews.count
    avg.round 1
  end
end

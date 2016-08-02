class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    return 0.0 if object.reviews.empty?
    object.rating
  end
end

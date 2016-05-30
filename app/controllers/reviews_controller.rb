class ReviewsController < ApplicationController
  before_filter :require_sign_in

  def create
    @video = Video.find(params[:video_id])
    @reviews = @video.reviews
    review = Review.new(review_params)
    review.video = @video
    review.user = current_user

    if review.save
      flash[:notice] = "Your review has been saved"
      redirect_to video_path(@video)
    else
      flash[:error] = "something went wrong, your review is not saved"
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end

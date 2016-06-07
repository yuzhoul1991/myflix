class QueueItemsController < ApplicationController
  before_filter :require_sign_in

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @video = Video.find(params[:video_id])
    if currently_queued?(@video)
      flash[:notice] = "This video is already in the queue"
      redirect_to video_path(@video)
    else
      queue_video @video
      redirect_to my_queue_path
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include? queue_item
    flash[:notice] = "The video has been removed from the queue"
    current_user.normalize_queue_item_position
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_position
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers"
    end
    redirect_to my_queue_path
  end

  private

    def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data['id'])
        queue_item.update_attributes!(position: queue_item_data['position'], video_rating: queue_item_data['rating']) if queue_item.user == current_user
      end
    end
  end

  def queue_video(video)
      QueueItem.create(video: @video, user: current_user, position: next_queue_item_position)
  end

  def next_queue_item_position
    current_user.queue_items.count + 1
  end

  def currently_queued?(video)
    current_user.queue_items.map(&:video).include? video
  end
end

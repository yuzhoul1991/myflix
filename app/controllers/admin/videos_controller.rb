class Admin::VideosController < AdminsController
  before_filter :require_sign_in

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:notice] = 'Video has been added'
      redirect_to new_admin_video_path
    else
      flash[:error] = 'Something went wrong when creating the video'
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit!
  end
end

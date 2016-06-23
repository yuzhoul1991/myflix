class PagesController < ApplicationController
  def front
    redirect_to home_path if logged_in?
  end

  def expired_token; end
end

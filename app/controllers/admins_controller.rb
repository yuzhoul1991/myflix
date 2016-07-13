class AdminsController < ApplicationController
  before_filter :require_sign_in
  before_filter :require_admin

  private

  def require_admin
    unless current_user.admin?
      flash[:error] = 'You do not have admin access'
      redirect_to home_path
    end
  end
end

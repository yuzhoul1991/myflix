class Admin::PaymentsController < AdminsController
  before_filter :require_sign_in

  def index
    @payments = Payment.all
  end
end

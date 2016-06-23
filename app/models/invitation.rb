class Invitation < ActiveRecord::Base
  include Tokenable
  
  belongs_to :inviter, class_name: User

  validates :recipient_email, presence: true
  validates :recipient_name, presence: true
  validates :message, presence: true
end

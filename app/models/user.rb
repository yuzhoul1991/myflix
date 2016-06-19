class User < ActiveRecord::Base
  has_many :reviews, -> { order "created_at desc" }
  has_many :queue_items, -> { order "position" }
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'

  has_secure_password validations: false

  validates_presence_of :email, :password, :fullname
  validates_uniqueness_of :email

  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def video_in_queue?(video)
    queue_items.map(&:video).include? video
  end

  def following?(other)
    return true if self == other
    following_relationships.map(&:leader).include? other
  end

  def generate_token
      self.update_attribute :token, SecureRandom.urlsafe_base64
  end
end

class RoomParticipant < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  
  validates :room_id, uniqueness: { scope: :user_id }
  
  after_create :notify_user_joined
  
  private
  
  def notify_user_joined
    # Notification logic here
    Rails.logger.info "User #{user.name} joined room #{room.name}"
  end
end
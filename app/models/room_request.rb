class RoomRequest < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  
  validates :status, inclusion: { in: %w[pending approved rejected] }
  
  scope :pending, -> { where(status: 'pending') }
  
  after_create :notify_room_creator
  
  private
  
  def notify_room_creator
    # You can implement notification system here
    Rails.logger.info "New room request from #{user.name} for #{room.name}"
  end
end

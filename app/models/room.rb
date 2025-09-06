class Room < ActiveRecord::Base
	   validates :name, presence: true, uniqueness: true
  
  has_many :messages, dependent: :destroy
  has_many :room_participants, dependent: :destroy
  has_many :room_requests, dependent: :destroy
  has_many :users, through: :room_participants
  
  scope :public_rooms, -> { where(private: false) }
  scope :private_rooms, -> { where(private: true) }
  
  def last_message
    messages.order(created_at: :desc).first
  end
  
  def unread_messages_count(user)
    participant = room_participants.find_by(user: user)
    return 0 unless participant
    
    messages.where('created_at > ?', participant.last_read_at || Time.at(0)).count
  end
  
  def mark_as_read(user)
    participant = room_participants.find_or_create_by(user: user)
    participant.update(last_read_at: Time.current)
  end
  
  def can_access?(user)
    return true unless private? # Public rooms are accessible to everyone
    return false unless user # No access for logged out users
    
    # Room creator has access
    return true if room_participants.any? && room_participants.first.user == user
    
    # Check if user is a participant
    room_participants.exists?(user: user)
  end
  
  def creator
    room_participants.first&.user
  end
  
  def has_pending_request?(user)
    room_requests.pending.exists?(user: user)
  end
end

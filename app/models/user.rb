class User < ActiveRecord::Base

   
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  has_many :messages
  has_many :room_participants
  has_many :rooms, through: :room_participants
  
  
  
  private
  
  def set_last_read_at
    self.last_read_at ||= Time.current
  end
end

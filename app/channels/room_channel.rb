class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room])
    stream_for room
    
    # Mark messages as read when user joins
    if current_user
      room.mark_as_read(current_user)
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # Handle incoming data if needed
  end
end
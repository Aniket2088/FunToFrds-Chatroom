class AddLastReadAtToRoomParticipants < ActiveRecord::Migration
  def change
    add_column :room_participants, :last_read_at, :datetime
  end
end

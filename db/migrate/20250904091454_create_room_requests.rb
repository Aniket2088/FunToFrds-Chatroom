class CreateRoomRequests < ActiveRecord::Migration
  def change
    create_table :room_requests do |t|
      t.references :room, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end

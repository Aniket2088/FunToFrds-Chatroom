class AddPrivateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :private, :boolean
  end
end

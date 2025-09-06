class AddLastMessageReadAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_message_read_at, :datetime
  end
end

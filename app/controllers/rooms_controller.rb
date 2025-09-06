class RoomsController < ApplicationController
  before_action :require_user
  
  def index
    @rooms = Room.all.order(created_at: :desc)
    @room = Room.new
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    @rooms = Room.all.order(created_at: :desc)
    
    render 'users/dashboard'
  end

  def create
    @room = Room.new(room_params)
    @room.private = params[:room][:private] == '1'
    
    if @room.save
      # Add the creator as a participant
      @room.room_participants.create(user: current_user)
      
      redirect_to room_path(@room), notice: 'Room was successfully created.'
    else
      @rooms = Room.all.order(created_at: :desc)
      @room_selected = nil
      render 'users/dashboard', status: :unprocessable_entity
    end
  end
  
  # ADD THIS ACTION
  def can_access
    @room = Room.find(params[:id])
    
    # Check if user can access the room
    can_access = @room.can_access?(current_user)
    
    # Check if user has pending request (only for private rooms)
    has_pending_request = @room.private? && @room.room_requests.pending.exists?(user: current_user)
    
    render json: {
      can_access: can_access,
      has_pending_request: has_pending_request,
      is_private: @room.private?
    }
  end

 def participants
  @room = Room.find(params[:id])
  
  # Get all users who are participants in this room
  participants = @room.users.distinct
  
  render json: participants.map { |user| 
    {
      id: user.id,
      name: user.name,
      email: user.email,
      initial: user.name[0].upcase,
      is_online: true # You can implement actual online status later
    }
  }
end

  def new_messages
    @room = Room.find(params[:id])
    last_message_id = params[:last_id].to_i
    
    # Get messages newer than the last_message_id
    @messages = @room.messages.where('id > ?', last_message_id)
                     .includes(:user)
                     .order(created_at: :asc)
    
    render json: @messages.map { |message| 
      {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_name: message.user.name,
        time: message.created_at.strftime('%H:%M')
      }
    }
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :private)
  end
end
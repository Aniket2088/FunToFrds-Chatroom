class RoomRequestsController < ApplicationController
  before_action :require_user
  before_action :set_room_request, only: [:approve, :reject]
  
  def my_requests
    # Get requests for rooms where current user is the creator
    my_rooms = Room.where(id: RoomParticipant.where(user: current_user).pluck(:room_id))
    @requests = RoomRequest.where(room_id: my_rooms, status: 'pending')
                          .includes(:user, :room)
    
    render json: @requests.map { |req| 
      {
        id: req.id,
        user_name: req.user.name,
        user_id: req.user.id,
        room_name: req.room.name,
        room_id: req.room.id,
        created_at: req.created_at.strftime('%Y-%m-%d %H:%M')
      }
    }
  end
  
  def create
    @room = Room.find(params[:room_id])
    
    if @room.private? && !@room.room_participants.exists?(user: current_user)
      @room_request = @room.room_requests.create(
        user: current_user,
        status: 'pending'
      )
      
      if @room_request.persisted?
        render json: { message: 'Join request sent successfully' }
      else
        render json: { errors: @room_request.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Cannot request to join this room'] }, status: :unprocessable_entity
    end
  end
  
  def approve
    if @room_request.room.room_participants.create(user: @room_request.user)
      @room_request.update(status: 'approved')
      render json: { message: 'Request approved successfully' }
    else
      render json: { errors: ['Failed to approve request'] }, status: :unprocessable_entity
    end
  end
  
  def reject
    @room_request.update(status: 'rejected')
    render json: { message: 'Request rejected successfully' }
  end
  
  def index
    @room = Room.find(params[:room_id])
    if @room.room_participants.exists?(user: current_user)
      @requests = @room.room_requests.pending.includes(:user)
      render json: @requests.map { |req| 
        {
          id: req.id,
          user_name: req.user.name,
          user_id: req.user.id,
          created_at: req.created_at.strftime('%Y-%m-%d %H:%M')
        }
      }
    else
      render json: { errors: ['Not authorized'] }, status: :unauthorized
    end
  end
  
  private
  
  def set_room_request
    @room_request = RoomRequest.find(params[:id])
  end
end
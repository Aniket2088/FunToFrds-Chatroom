class MessagesController < ApplicationController
  before_action :require_user
  
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to @room }
        format.json { render json: {
          id: @message.id,
          content: @message.content,
          user_id: @message.user_id,
          user_name: @message.user.name,
          time: @message.created_at.strftime('%H:%M')
        } }
      end
    else
      respond_to do |format|
        format.html do
          @messages = @room.messages.includes(:user).order(created_at: :asc)
          render 'rooms/show'
        end
        format.json { render json: { errors: @message.errors }, status: :unprocessable_entity }
      end
    end
  end
  
  def index
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user).order(created_at: :asc)
    
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

  def message_params
    params.require(:message).permit(:content)
  end
end

module Api::V1
  class UsersController < ApplicationController



        def sign_in
          user = User.find_by(email: params[:email])
          if user.password == params[:password]
            session[:user_id] = user.id
            render json: { 
          status: 'success', 
          message: 'User Logged in successfully', 
          user: user 
        }, status: :created
      else
        render json: { 
          status: 'error', 
          message: 'Failed to Login user',
          errors: user.errors.full_messages 
        }, status: :unprocessable_entity
      end

        end

    end
  end

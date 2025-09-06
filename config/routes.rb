Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create] do
        collection do
          post :sign_in
          post :signup
        end
      end
    end
  end
  root 'users#dashboard'
  
  # Standard RESTful routes for users
  resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  
  # User authentication routes
  get 'signup', to: 'users#index', as: 'signup'
  post 'signup', to: 'users#create'
  get 'signin', to: 'users#sign_in', as: 'signin'
  post 'signin', to: 'users#authenticate'
  get 'signout', to: 'users#sign_out', as: 'signout'
  
  # Rooms and messages
  resources :rooms do
    resources :messages, only: [:create, :index]
    resources :room_requests, only: [:create, :index] do
      member do
        post 'approve'
        post 'reject'
      end
    end
    
    # Add this within the rooms resources block
    member do
      get 'can_access'
       get 'participants'
         get 'new_messages' # Add this for polling
    end
  end
  
  # User's room requests - FIXED ROUTE
  get 'my_room_requests', to: 'room_requests#my_requests'
  
  # Dashboard
  get 'dashboard', to: 'users#dashboard'
end
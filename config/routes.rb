Rails.application.routes.draw do
  resources :private_chats, param: :recipient_id
  
  resources :users, shallow: true do
    resource :user_info
  end

  resources :groups
  match "/groups/join", to: "groups#join", via: [:post]
  get "/joined_groups", to: "groups#joined_groups"
  get "/groups/:id/messages", to: "groups#messages"
  resource :session
  match "logout", to: "sessions#destroy", via: [:post]
  resources :passwords, param: :token
  resources :messages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

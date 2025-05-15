Rails.application.routes.draw do
  resources :users, shallow: true do
    resources :private_chats, param: :recipient_id
    resource :user_info
  end

  resources :groups
  resource :session
  resources :passwords, param: :token
  resources :messages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

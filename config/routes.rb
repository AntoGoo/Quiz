Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  get "/.well-known/appspecific/com.chrome.devtools.json", to: proc { [404, {}, ["Not Found"]] }
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :quizzes, only: [:index, :show]

  resources :game_sessions, only: [:new, :show, :create] do
    member do
      post "submit_answer"
    end
  end

  # Route pour afficher le classement des scores
  resources :scores, only: [:index]
  resources :players, only: [:new, :create]
  # Back-office via un namespace admin
  namespace :admin do
    resources :quizzes do
      resources :questions, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :options
    end
  end

  mount ActionCable.server => '/cable'
end

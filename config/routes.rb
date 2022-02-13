require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        get :answers, on: :member
      end

      resources :answers, only: %i[show create update destroy]
    end
  end

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable] do
      member do
        patch :best_answer
      end
    end
    resources :followings, only: %i[create]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :comments, only: %i[create destroy]
  resources :followings, only: %i[destroy]

  get 'search', to: 'search#search'

  resources :authorizations, only: %i[new create] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  mount ActionCable.server => '/cable'
end

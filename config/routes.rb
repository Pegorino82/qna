Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

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
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :comments, only: %i[create destroy]

  resources :authorizations, only: %i[new create] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  mount ActionCable.server => '/cable'
end

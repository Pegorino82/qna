Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best_answer
      end
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end

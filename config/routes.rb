Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, only: :create
  end
end

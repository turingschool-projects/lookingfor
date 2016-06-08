Rails.application.routes.draw do
  root 'home#index'

  resources :jobs, only: [:show]
  resources :companies, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index]
      get '/last_two_months', to: "jobs#last_two_months"
    end
  end
end

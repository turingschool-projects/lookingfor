Rails.application.routes.draw do

  root 'home#index'

  resources :jobs, only: [:show]
  resources :companies, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show]
      resources :companies, only: [:show]
      # get '/companies/:id', to: "jobs#by_company"
      get '/recent_jobs', to: "recent_jobs#index"
    end
  end
end

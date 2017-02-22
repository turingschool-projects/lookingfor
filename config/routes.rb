Rails.application.routes.draw do

  root 'home#index'

  resources :jobs, only: [:show]
  resources :companies, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show]
      resources :companies, only: [:show]
      get '/recent_jobs', to: "recent_jobs#index"
      get '/current_openings_technology_count', to: "trends#current_openings_technology_count"
      get '/company_jobs/:id', to: 'company_jobs#index'
    end
  end
end

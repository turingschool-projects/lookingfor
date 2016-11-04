Rails.application.routes.draw do

  root 'home#index'

  resources :jobs, only: [:show]
  resources :companies, only: [:show]

  post '/jobs_email' to: "home#send_jobs_email"

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show]
      resources :companies, only: [:show]
      get '/recent_jobs', to: "recent_jobs#index"
      get '/current_openings_technology_count', to: "trends#current_openings_technology_count"
    end
  end
end

require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json }, 
                  constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1 do
      # resources
      resources :users, only: [:show, :create]
    end
  end
end

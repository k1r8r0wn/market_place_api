require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # resources
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :products, only: [:create, :update, :destroy]
        resources :orders, only: [:index, :show, :create]
      end
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:index, :show]
    end
  end
end

# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # resources
      resources :users, only: %i[show create update destroy] do
        resources :products, only: %i[create update destroy]
        resources :orders, only: %i[index show create]
      end
      resources :sessions, only: %i[create destroy]
      resources :products, only: %i[index show]
    end
  end
end

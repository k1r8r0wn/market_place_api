Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }, 
                  constraints: { subdomain: 'api' }, path: '/' do
  end
end

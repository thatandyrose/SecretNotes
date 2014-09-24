Rails.application.routes.draw do
  root to: 'visitors#index'

  namespace :api do
    namespace :v1 do
      resources :notes, only: [:create, :show]
    end
  end
end

Rails.application.routes.draw do
  resources :events, except: %w(show)

  root to: 'events#index'
end

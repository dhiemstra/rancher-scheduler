Rails.application.routes.draw do
  resources :events, except: %w(show)

  match 'ping', to: proc { [200, {}, ['']] }

  root to: 'events#index'
end

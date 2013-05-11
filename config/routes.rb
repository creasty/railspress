RailsPress::Application.routes.draw do

  # OmniAuth
  get '/auth/:provider/callback' => 'oauth#callback'
  get '/logout' => 'sessions#destroy', :as => :logout

  # Device
  devise_for :users

  # Admin
  namespace :admin do
    root to: 'admin#index'

    resources :pages
    resources :posts do
      collection do
        get :search
      end
    end
    resources :comments
    resources :terms do
      collection do
        get :search
      end
    end
    resources :taxonomies
    resources :users
    resources :media
  end

  # Blog
  resources :posts,
    only: %w[index show] \
  do
    resources :comments
  end

  # Page
  resources :pages,
    path: '/',
    only: %w[index show]

end

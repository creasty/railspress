RailsPress::Application.routes.draw do

  devise_for :users

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

  resources :posts,
    only: %w[index show] \
  do
    resources :comments
  end

  resources :pages,
    path: '/',
    only: %w[index show]

end

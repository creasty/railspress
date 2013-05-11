RailsPress::Application.routes.draw do

  # Device
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }

  # OmniAuth
  get '/auth/:provider/callback' => 'oauth#callback'

  # Admin
  namespace :admin do
    root to: 'admin#index'

    resources :pages
    resources :posts do
      collection do
        get :search
      end
    end
    resources :terms do
      collection do
        get :search
      end
    end

    resources :comments
    resources :taxonomies
    resources :users
    resources :media
  end

  # Blog
  resources :posts, only: %w[index show] do
    resources :comments
  end

  # Page
  root to: 'pages#index'
  resources :pages, path: '/', only: :show

end

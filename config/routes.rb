RailsPress::Application.routes.draw do

  #  Admin
  #-----------------------------------------------
  namespace :admin do
    root to: 'admin#index'

    devise_scope :user do
      get '/login' => 'admin#login'
      get '/logout' => 'admin#logout'
    end

    resources :pages
    resources :posts
    resources :terms
    resources :comments
    resources :taxonomies
    resources :users
    resources :media
  end

  #  Device for Commenter
  #-----------------------------------------------
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }

  #  OmniAuth
  #-----------------------------------------------
  get '/auth/:provider/callback' => 'oauth#callback'

  #  Commenter
  #-----------------------------------------------
  get '/commenter' => 'users#edit'
  put '/commenter' => 'users#update'
  delete '/commenter' => 'users#destroy'

  #  Blog
  #-----------------------------------------------
  resources :posts, only: %w[index show] do
    resources :comments, only: %w[edit]
  end

  #  Pages / Static Pages
  #-----------------------------------------------
  root to: 'pages#index'
  get '/:id(/:id2)(/:id3)' => 'pages#show', as: :page

end

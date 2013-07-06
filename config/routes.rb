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
    resources :posts do
      collection do
        get :comments, to: 'comments#inbox'
        get :tags
      end

      resources :comments
    end
    resources :users
    resources :media
    resources :notifications, except: %w[show edit]
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
  get '/auth/:provider/callback' => 'oauths#callback'
  delete '/auth/:provider' => 'oauths#destroy'

  #  Commenter
  #-----------------------------------------------
  get :commenter, to: 'users#edit'
  put :commenter, to: 'users#update'
  delete :commenter, to: 'users#destroy'

  #  Blog
  #-----------------------------------------------
  resources :posts, only: %w[index show] do
    resources :comments
  end

  #  Pages / Static Pages
  #-----------------------------------------------
  root to: 'pages#index'
  get '/:id(/:id2)(/:id3)' => 'pages#show', as: :page

end

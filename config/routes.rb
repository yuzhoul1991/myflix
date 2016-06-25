require 'sidekiq/web'

Myflix::Application.routes.draw do
  root to: 'pages#front'
  mount Sidekiq::Web => '/sidekiq'

  get 'ui(/:action)', controller: 'ui'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: 'users#new'
  get 'people', to: 'relationships#index'
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'pages#expired_token'
  get 'register/:token', to: 'users#new_with_invitation', as: 'new_with_invitation'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :relationships, only: [:destroy, :create]
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :invitations, only: [:new, :create]

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :sessions, only: [:new, :create, :destroy]
end

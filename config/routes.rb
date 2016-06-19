Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: 'users#new'
  get 'people', to: 'relationships#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :relationships, only: [:destroy, :create]
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :sessions, only: [:new, :create, :destroy]
end

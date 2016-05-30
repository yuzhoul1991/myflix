Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'

  get 'register', to: 'users#new'
  resources :users, only: [:create]

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'home', to: 'videos#index'
  get 'category/:id', to: 'categories#show'

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :sessions, only: [:new, :create, :destroy]
end

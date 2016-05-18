Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'videos#index'
  get '/category/:id', to: 'categories#show'
  resources :videos, only: [:show]
end

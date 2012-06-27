Slit::Application.routes.draw do
  resources :repositories
  resources :keys
  devise_for :users
  root :to => 'home#index'
end

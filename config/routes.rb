Slit::Application.routes.draw do
  resources :repositories
  resources :keys
  resources :jobs

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'home#index'

  match ':user' => 'repositories#index'
  match ':user/:repository' => 'repositories#show'
  match ":user/:repository/commits/:branch" => "repositories#commits"
  match ":user/:repository/commit/:branch" => "repositories#commit"
  match ":user/:repository/tree/:branch" => "repositories#tree"
  match ":user/:repository/tree/:branch/:path" => "repositories#tree",
    :constraints => {:path => /.*/}
  match ":user/:repository/blob/:branch/:path" => "repositories#blob",
    :constraints => {:path => /.*/}
end

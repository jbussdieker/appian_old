Slit::Application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :repositories do
    member do
      match "commits/:branch" => "repositories#commits", :as => "commits"
      match "commit/:branch" => "repositories#commit", :as => "commit"
      match "tree/:branch" => "repositories#tree", :as => "tree"
      match "tree/:branch/:path" => "repositories#tree", :constraints => {:path => /.*/}, :as => "tree"
      match "blob/:branch/:path" => "repositories#blob", :constraints => {:path => /.*/}, :as => "blob"
    end
  end
  resources :keys
  resources :storage do
    member do
      match ":path" => "storage#show", :constraints => {:path => /.*/}, :as => "object"
    end
  end
  resources :servers
  resources :job_types, :path => "/jobs/types"
  resources :job_environments, :path => "/jobs/environments"
  resources :jobs do
    resources :builds do
      member do
        get 'log'
      end
    end
    member do
      get 'build'
    end
  end

  match 'api/:action' => 'api#index'
end

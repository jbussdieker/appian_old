Slit::Application.routes.draw do
  resources :repositories do
    match "/commits/:branch" => "repositories#commits", :via => :get
    match "/tree/:branch/:path" => "repositories#tree", :via => :get,
      :constraints => {:path => /.*/}
    match "/blob/:branch/:path" => "repositories#blob", :via => :get,
      :constraints => {:path => /.*/}
  end
  resources :keys
  devise_for :users
  root :to => 'home#index'
end

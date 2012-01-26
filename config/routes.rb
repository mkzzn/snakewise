Contented::Application.routes.draw do
  devise_for :users
  resources :users

  match '/search' => 'articles#search', :as => :search

  resources :fortunes do
    get 'feed', :on => :collection
    get 'search', :on => :collection
  end

  resources :headlines do
    get 'feed', :on => :collection
    get 'search', :on => :collection
  end

  get "home/index"

  root :to => "pages#homepage"
end

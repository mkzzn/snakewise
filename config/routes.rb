Contented::Application.routes.draw do
  devise_for :users
  resources :users
  match '/writers/:id' => "users#show", :as => 'writer'
  match '/writers' => "pages#writers", :as => 'writers_page'

  resources :articles do
    resources :comments
    get 'feed', :on => :collection
  end

  match '/feed' => 'articles#feed', :as => :feed, :defaults => { :format => 'atom' }
  match '/search' => 'articles#search', :as => :search

  resources :categories do
    resources :articles
  end

  resources :fortunes do
    resources :comments
    get 'feed', :on => :collection
  end

  resources :comments

  get "home/index"

  root :to => "pages#homepage"
end

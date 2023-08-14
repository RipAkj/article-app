Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'pages#home'
  get 'about', to: 'pages#about'

  #articles
  resources :articles

  post 'signup', to: 'users#create'
  resources :users, except: [:new]
  post '/auth/login', to: 'authentication#create'

  resources :friendships, only: [:destroy]
  post 'friendships/:id', to: 'friendships#create'
  get 'showFollowers/:id', to: 'friendships#showFollowers'
  get 'showFollowing/:id', to: 'friendships#showFollowing'

  get 'userSearch', to: 'operations#userSearch'
  get 'articleSearch', to: 'operations#articleSearch'
  get 'topicSearch', to: 'operations#searchTopic'
  get 'topArticles', to: 'operations#topArticles'
  get 'similarArticles', to: 'operations#similarArticles'
  get 'listTopic', to: 'operations#listTopic'
  get 'recommendedArticles/:id', to: 'operations#recommendedArticles'
  get 'showArticle', to: 'operations#showArticle'
  get 'sortByLike', to: 'operations#sortByLike'
  get 'sortByComment', to: 'operations#sortByComment'

  resources :comments, only: [:create, :update, :destroy, :show]
  post 'likes/:id', to: 'likes#create'

  post '/articles/viewed/:id', to: 'viewedarticles#create'

  resources :drafts, only: [:show, :index, :create, :update, :destroy]

  resources :lists, only: [:show, :index, :create, :update, :destroy]
  resources :listitems, only: [:create, :destroy]
  post 'listShare', to: 'lists#listShare'

  resources :saveforlaters, only: [:destroy, :index]
  post 'saveforlaters/:id', to: 'saveforlaters#create'

  post 'payments', to: 'payments#create'
  post 'verify_payment', to: 'payments#verify_payment'
end

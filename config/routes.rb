Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles
  post 'signup', to: 'users#create'
   resources :users, except: [:new]
   post '/auth/login', to: 'authentication#create'
  get 'showArticle', to: 'users#showArticle'
  get 'sortByLike', to: 'articles#sortByLike'
  get 'sortByComment', to: 'articles#sortByComment'
  resources :friendships
  get 'userSearch', to: 'users#search'
  get 'articleSearch', to: 'articles#search'
  get 'topicSearch', to: 'articles#searchTopic'
  get 'topArticles', to: 'articles#topArticles'
  get 'similarArticles', to: 'articles#similarArticles'
  get 'listTopic', to: 'articles#listTopic'
  get 'recommendedArticles', to: 'users#recommendedArticles'
  get 'showFollowers', to: 'friendships#showFollowers'
  get 'showFollowing', to: 'friendships#showFollowing'
end

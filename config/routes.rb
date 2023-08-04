Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles
  post 'signup', to: 'users#create'
   resources :users, except: [:new]
   post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'showArticle', to: 'users#showArticle'
end
end
end

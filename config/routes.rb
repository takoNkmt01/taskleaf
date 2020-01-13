Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  
  #namespace :adminで定義しているためヘルパーメソッドの先頭には'admin_'が付与される
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks
end

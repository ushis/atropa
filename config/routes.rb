Atropa::Application.routes.draw do

  # Public routes
  root :to => 'public#index'

  get  'videos(/:page)'          => 'public#index'
  get  'tag/:id(/:slug(/:page))' => 'public#tag',             as: :tag
  get  'video/:id(/:slug)'       => 'public#video',           as: :video
  get  'feed'                    => 'public#feed',            as: :feed
  get  'search(/:q(/:page))'     => 'public#search',          as: :search
  post 'search'                  => 'public#redirect_search', as: :search

  # Admin routes
  get 'admin(/videos/:page)' => 'admin/videos#index', as: :admin

  namespace :admin do
    resources :videos
    resources :users
    get    'login' => 'login#form'
    post   'login' => 'login#login'
    delete 'login' => 'login#logout'
  end
end

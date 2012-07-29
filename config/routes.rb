Atropa::Application.routes.draw do

  # Public routes
  root :to => 'public#index'

  get  'videos(/:page)'          => 'public#index'
  get  'tag/:id(/:slug(/:page))' => 'public#tag',             as: :tag
  get  'video/:id(/:slug)'       => 'public#video',           as: :video
  get  'feed'                    => 'public#feed',            as: :feed
  get  'search(/:q(/:page))'     => 'public#search',          as: :search
  post 'search'                  => 'public#redirect_search', as: :search

  scope module: :public do
    resources :graphs, only: :index do
      collection do
        get 'fishnet'
        get 'tagmap'
        get 'fountain'
      end
    end
  end

  # Admin routes
  get 'admin(/videos/:page)' => 'admin/videos#index', as: :admin

  namespace :admin do
    resources :videos, except: [:new, :show]

    get 'profile' => 'users#profile'
    put 'profile' => 'users#update'

    get    'login' => 'login#form'
    post   'login' => 'login#login'
    delete 'login' => 'login#logout'

    get 'forgot/password'            => 'login#forgot_password'
    put 'forgot/password'            => 'login#request_password_reset'
    get 'reset/password/:reset_hash' => 'login#reset_password', as: 'reset_password'
    put 'reset/password/:reset_hash' => 'login#update_password'
  end

  # Api routes
  namespace :api do
    resources :users, only: :show
    resources :videos, except: [:new, :edit]
    resources :tags, except: [:new, :create, :edit]
  end
end

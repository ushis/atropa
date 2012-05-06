Atropa::Application.routes.draw do
  root :to => 'public#index'

  get 'admin(/videos/:page)' => 'admin/videos#index', :as => :admin

  namespace :admin do
    resources :videos
    resources :users
    get    'login' => 'login#form'
    post   'login' => 'login#login'
    delete 'login' => 'login#logout'
  end
end

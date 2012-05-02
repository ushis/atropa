Atropa::Application.routes.draw do
  namespace :admin do
    resources :videos
    get    'login'    => 'login#form'
    post   'login'   => 'login#login'
    delete 'login' => 'login#logout'
  end

  get 'admin' => 'admin/videos#index'

  root :to => 'public#index'
end

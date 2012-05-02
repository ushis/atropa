Atropa::Application.routes.draw do
  namespace :admin do
    get 'login'    => 'login#form'
    post 'login'   => 'login#login'
    delete 'login' => 'login#logout'
  end

  get 'admin' => 'admin/videos#index'
end

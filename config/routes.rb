Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'users/me', to: 'users#me'
      post 'users/login', to: 'users#login'
      post 'users/register', to: 'users#register'
      delete 'users/logout', to: 'users#logout'
      get 'users/:id', to: 'users#show', :constraints  => { :id => /[0-z\.]+/ }

      resources :users
    end
  end
end

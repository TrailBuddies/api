Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resource :hike_events do
        get '/', to: 'hike_events#index'
        post '/create', to: 'hike_events#create'
        get '/:id', to: 'hike_events#show'
        put '/:id', to: 'hike_events#update'
        delete '/:id', to: 'hike_events#destroy'
        post '/:id/join', to: 'hike_events#join'
        delete '/:id/leave', to: 'hike_events#leave'
        post '/:id/confirm/:uid', to: 'hike_events#confirm'
      end

      resource :users do
        get '/', to: 'users#index', on: :collection
        get '/me', to: 'users#me', on: :collection
        put '/me/avatar', to: 'users#update_avatar', on: :collection
        put '/confirm_email', to: 'users#confirm_email', on: :collection
        post '/login', to: 'users#login', on: :collection
        post '/register', to: 'users#register', on: :collection
        delete '/logout', to: 'users#logout', on: :collection
        put '/change_password', to: 'users#change_password', on: :collection
        get '/:id', to: 'users#show', on: :collection

        get '/me/hike_events', to: 'hike_events#current_user', on: :collection
        get '/:id/hike_events', to: 'hike_events#show_for_user', on: :collection
      end
    end
  end
end

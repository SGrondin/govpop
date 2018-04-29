Rails.application.routes.draw do
  defaults format: :json do

    root 'application#index'

    post '/users/register', to: 'users#create'
    post '/users/activate', to: 'users#activate'
    post '/users/pw/edit', to: 'users#change_password'
    post '/users/pw/reset', to: 'users#reset_password'
    post '/users/pw/forgot', to: 'users#forgot_password'
    get '/users', to: 'users#show'

    get '/users/session', to: 'sessions#show'
    delete '/users/session', to: 'sessions#destroy'
    post '/users/session', to: 'sessions#create'

    get '/users/profile', to: 'profiles#show'
    put '/users/profile', to: 'profiles#update'

    get '/questions', to: 'questions#index'
    get '/questions/:id', to: 'questions#show'
    post '/questions', to: 'questions#create'
    put '/questions/:id', to: 'questions#update'

    post '/questions/:id/vote', to: 'questions#vote'

    match '*path', controller: 'application', action: 'index', conditions: {method: :options}, via: :options

  end
end

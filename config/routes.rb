Rails.application.routes.draw do
  devise_for :users,
    # devise_for :users
    # namespace :api, defaults: {format: :json} do
    #     namespace :v1 do 
    #       devise_scope :user do
    #         post "sign_up", to: "registrations#create"
    #         post "sign_in", to: "sessions#create"
    #       end
    #     end
    #   end
    # devise_for :users,
    # path: '',
    # path_names: {
    #     sign_in: 'login',
    #     sign_out: 'logout',
    #     registration: 'signup'
    # },
    controllers: {
        sessions: 'sessions',
        registrations: 'registrations'
    }
        resources :articles, only: [:index, :show]
    get '/articles/:id', to: 'articles#show'
end

Rails.application.routes.draw do
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

   resources :users
   resources :account_activations, only: [:edit]
   resources :password_resets,     only: [:new, :create, :edit, :update]
   resources :microposts,          only: [:create, :destroy]

   get '/nowy-uczen', to: 'users#new'
   post '/nowy-uczen', to: 'users#create'

   root 'static_pages#home' # 'podaj_slowko#losuj_obrazek'
   post "/", to: 'podaj_slowko#check'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   get '/what-can-you-see', to: 'podaj_slowko#losuj_obrazek'
   post '/what-can-you-see', to: 'podaj_slowko#check'
   get "check", to: 'podaj_slowko#check'


end

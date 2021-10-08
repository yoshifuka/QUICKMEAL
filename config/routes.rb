Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :dishes
  resources :users, only: :show
  resources :comments, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

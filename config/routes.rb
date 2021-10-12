Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :dishes
  resources :users, only: :show
  resources :comments, only: [:create, :destroy]
  get :favorites, to: 'favorites#index'
  post 'favorites/:dish_id/create'  => 'favorites#create', as: 'create_favorites'
  delete 'favorites/:dish_id/destroy' => 'favorites#destroy', as: 'destroy_favorites'
end

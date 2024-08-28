Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'hello#index'

  get 'products/search' => 'search#products_show'

  resources :products, only: %i[index show]

  resources :orders, only: %i[create index]

  patch 'cart/put_product' => 'carts#put_product'

  patch 'cart/add_product' => 'carts#add_product'

  patch 'cart/sub_product' => 'carts#sub_product'

  patch 'cart/remove_product' => 'carts#remove_product'

  get 'cart/show' => 'carts#show'

  namespace :admin do
    root 'products#index'

    get 'products/search' => 'search#products_show'

    get 'orders/search' => 'search#orders_show'

    resources :products, only: %i[create index update edit new] do
      patch :purge_image, on: :member
    end

    resources :users, only: %i[index]

    resources :orders, only: %i[index show]do
      patch :dismiss_details
    end

    resources :properties
  end
end

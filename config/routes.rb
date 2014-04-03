Bioseminars::Application.routes.draw do

  devise_for :users

  resources :buildings, only: [:index, :show, :create, :update, :destroy]
  resources :categories, only: [:index, :show, :create, :update, :destroy]
  resources :categorisations, only: [:create, :update, :destroy]
  resources :hosts, only: [:index, :show, :create, :update, :destroy]
  resources :hostings, only: [:create, :update, :destroy]
  resources :locations, only: [:index, :show, :create, :update, :destroy]
  resources :seminars, only: [:index, :show, :create, :update, :destroy]
  resource :session, only: [:create, :destroy]
  resources :users, only: [:index, :show, :create, :update, :destroy] do
    member do
      get :authenticate
    end
  end

  namespace :api do
    namespace :v2 do
      resources :seminars, only: [:index, :show]
    end
  end

  root :to => 'application#index'

end

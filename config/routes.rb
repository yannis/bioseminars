Seminars::Application.routes.draw do
  devise_for :users
  resources :buildings
  resources :categories do
    collection do
      put :reorder
    end
    resources :seminars do
      collection do
        post :sort
      end
    end
  end
  resources :hosts
  resources :locations
  resources :seminars do
    member do
      get :load_publications
    end
    collection do
      get :validate_pubmed_ids
      get :calendar
    end
  end
  # resource :session
  resources :users do
    resources :seminars
  end
  
  # match '/logout' => 'sessions#destroy'
  # match '/login' => 'sessions#new'
  # match '/signup' => 'users#new'
  # match '/forgot_password' => 'users#forgot_password'
  # match '/reset_password/:reset_code' => 'users#reset_password', :reset_code => nil
  match "/iframe" => "seminars#calendar", :as => :iframe, :format => :iframe
  match '/feeds' => 'feeds#index'
  match '/back' => 'seminars#back'
  match '/about' => 'seminars#about'
  root :to => 'seminars#calendar'
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', to: 'search#find_all'
      end
      namespace :items do
        get '/find', to: 'search#find_one'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show, :create, :update, :destroy] do
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, module: :items, only: [:show, :index]
      end
    end
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'books#index'

  resources :books, except: [:new, :edit] do
    resources :comments, except: [:new, :edit]

    resources :favorites, only: [:create, :destroy]
    resources :wishlists, only: [:create, :destroy]

    member do
      post 'rate'
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  resources :users, only: [:show] do
    collection do
      put 'update'
    end

    member do
      post 'follow'
      delete 'unfollow'
    end
  end

end

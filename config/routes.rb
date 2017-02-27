Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
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
      get :following, :followers, :favorite_books, :books_to_read
      post 'follow'
      delete 'unfollow'
    end
  end
end

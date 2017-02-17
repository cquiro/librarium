Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'books#index'

  resources :books, only: [:show, :index, :create]

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  resources :users, only: [:show] do
    collection do
      put 'update'
    end
  end

end

Projectsapp::Application.routes.draw do
  resources :tasks, :only => [:index, :create, :edit, :update, :destroy, :show] do
    put :change_status
    put :change_priority
  end

  resources :projects, :only => [:index, :create, :edit, :update, :destroy, :show]

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        confirmations: 'users/confirmations',
        passwords: 'users/passwords',
        unlocks: 'users/unlocks'
  }

  root to: 'projects#index'

  # devise_scope :user do
  #   get "/" => 'projects#index'
  # end 
end


Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth_user' => 'authentication#authenticate_user'
  resources :tasks
  resources :users
  patch '/tasks/:id/toggle', to: 'tasks#toggle'

end

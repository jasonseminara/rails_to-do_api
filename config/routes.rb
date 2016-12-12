Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
  patch '/tasks/:id/toggle', to: 'tasks#toggle'
end

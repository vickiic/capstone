Rails.application.routes.draw do
  resources :infos
  get 'infos/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'infos#index'
end

Rails.application.routes.draw do
  get 'stats/index'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/stats/index/:id', to: 'stats#index'
  post 'welcome/index', to: 'welcome#search'

  root 'welcome#index'
end

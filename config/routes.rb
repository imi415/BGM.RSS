Rails.application.routes.draw do
  resources :items
  resources :feeds

  get '/bangumi', to: 'bgm#index'
end

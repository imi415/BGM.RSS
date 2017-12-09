Rails.application.routes.draw do
  resources :items
  resources :feeds

  root to: 'static#index'
  get '/bangumi', to: 'bgm#index'
  get '/bangumi/:id', to: 'bgm#bangumi', as: 'bangumi_show'
  get '/ep/:id', to: 'bgm#play', as: 'bangumi_play'
  get '/cover/:id', to: 'bgm#cover', as: 'bangumi_cover'
end

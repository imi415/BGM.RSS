Rails.application.routes.draw do
  resources :items
  resources :feeds

  get '/bangumi', to: 'bgm#index'
  get '/bangumi/:id', to: 'bgm#bangumi', as: 'bangumi_show'
  get '/bangumi/play/:id', to: 'bgm#play', as: 'bangumi_play'
end

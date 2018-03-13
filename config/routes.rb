Rails.application.routes.draw do
  resources :items
  resources :feeds

  root to: 'static#index'

  get '/bangumi', to: 'bgm#index', as: 'bangumi_index'
  get '/bangumi/timeline', to: 'bgm#timeline', as: 'bangumi_timeline'
  get '/bangumi/:id', to: 'bgm#bangumi', as: 'bangumi_show'
  get '/ep/:id', to: 'bgm#play', as: 'bangumi_play'
  get '/cover/:id', to: 'bgm#cover', as: 'bangumi_cover'


  get '/tasks', to: 'cron_task#index', as: 'cron_task_index'
  get '/tasks/:name/enqueue', to: 'cron_task#enqueue', as: 'cton_task_enqueue'
end

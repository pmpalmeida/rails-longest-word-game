Rails.application.routes.draw do
  get 'pages/game'

  get 'pages/score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'pages/score'
end

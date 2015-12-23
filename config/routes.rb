Rails.application.routes.draw do
  resources :users, only: [:show, :create, :update, :destroy]
  resources :games, only: [:show, :create, :update, :destroy]

  post '/games/:id/make_move' => 'games#make_move'
  get '/games/:id/status' => 'games#status' # Add route for function that checks if anybody has won 

end

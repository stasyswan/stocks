Rails.application.routes.draw do
  resources :stocks, only: [:index, :create, :update, :destroy]
end

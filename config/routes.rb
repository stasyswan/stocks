Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      resources :stocks, only: [:index, :create, :update, :destroy]
    end
  end
end

Rails.application.routes.draw do
  resources :owners, only: [:index, :show]
  resources :pets, only: [:index, :show]
  resources :vets, only: [:index, :show]
  resources :appointments, only: [:index, :show]

  # Ruta principal
  root "owners#index"

  get "up" => "rails/health#show", as: :rails_health_check
end

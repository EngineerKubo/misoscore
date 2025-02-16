Rails.application.routes.draw do
  get 'ingredients/index'

  get "up" => "rails/health#show", as: :rails_health_check
end

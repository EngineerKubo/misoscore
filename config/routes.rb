Rails.application.routes.draw do
  get 'ingredients/index'
  post 'calculate', to: 'ingredients#calculate'

  get "up" => "rails/health#show", as: :rails_health_check
end

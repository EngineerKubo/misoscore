Rails.application.routes.draw do
  root 'ingredients#index'
  post 'ingredients/calculate', to: 'ingredients#calculate'
end
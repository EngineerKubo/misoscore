Rails.application.routes.draw do
  root 'ingredients#index'
  post 'ingredients/calculate', to: 'ingredients#calculate'
  get 'ingredients/result', to: 'ingredients#result'  # ← 修正
end

class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
  end

  def calculate
    selected_names = params[:ingredients] || []
    session[:selected_ingredients] = selected_names  # 選択データをセッションに保存
    redirect_to ingredients_result_path  # `result` ページにリダイレクト
  end

  def result
    selected_names = session[:selected_ingredients] || []
    @selected_ingredients = Ingredient.all.select { |ing| selected_names.include?(ing.name) }
    @total_calories = @selected_ingredients.sum(&:calories)
  end
end

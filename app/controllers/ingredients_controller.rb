class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
  end

  def calculate
    selected_names = params[:ingredients] || []
    @selected_ingredients = Ingredient.all.select { |ing| selected_names.include?(ing.name) }
    @total_calories = @selected_ingredients.sum(&:calories)
  end
end
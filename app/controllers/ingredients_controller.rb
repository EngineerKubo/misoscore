class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
  end

  def calculate
  end
end

require 'csv'

class Ingredient
  attr_reader :name, :calories

  def initialize(name, calories)
    @name = name
    @calories = calories.to_f
  end

  def self.all
    file_path = Rails.root.join('db', 'Ingredients.csv')
    ingredients = []

    CSV.foreach(file_path, headers: true) do |row|
      ingredients << Ingredient.new(row['食品名'], row['エネルギー（kcal）'])
    end

    ingredients
  end
end

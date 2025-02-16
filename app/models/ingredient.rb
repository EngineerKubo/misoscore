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

    CSV.foreach(file_path, headers: true, encoding: 'UTF-8') do |row|

      # Rails.logger.debug "CSV Row: #{row.to_h}"

      name = row['食品名'] || row[0]
      calories = row['エネルギー（kcal）'] || row[1]

      ingredients << Ingredient.new(name, calories) if name && calories
    end

    ingredients
  end
end

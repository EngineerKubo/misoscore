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

      name = row['食品名'] || row[0]
      calories = row['エネルギー（kcal）'] || row[1]

      next if name.nil? || name.strip.empty?

      if calories.nil? || !(calories.to_s =~ /\A\d+(\.\d+)?\z/)
        Rails.logger.warn "無効なカロリー値: #{calories} (具材: #{name})"
        next
      end

      ingredients << Ingredient.new(name, calories)
    end

    ingredients
  end
end

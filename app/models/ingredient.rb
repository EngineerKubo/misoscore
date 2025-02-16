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
      # デバッグ用のログを出力
      Rails.logger.debug "CSV Row: #{row.to_h}"

      # ヘッダーのカラム名を確認して適切に取得
      name = row['食品名'] || row['name'] || row[0]  # カラム名が違う場合に対応
      calories = row['エネルギー（kcal）'] || row['calories'] || row[1] # カラム名が違う場合に対応

      if name && calories
        ingredients << Ingredient.new(name, calories)
      else
        Rails.logger.warn "Skipping row due to missing values: #{row.to_h}"
      end
    end

    ingredients
  end
end
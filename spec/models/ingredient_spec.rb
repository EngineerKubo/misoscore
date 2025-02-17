require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe '.all' do
    let(:csv_path) { Rails.root.join('db', 'test_ingredients.csv') }

    before do
      File.write(csv_path, "食品名,エネルギー（kcal）\n豆腐,100\nわかめ,10\n")  
    end

    after do
      File.delete(csv_path) if File.exist?(csv_path)
    end

    it 'CSV から正しくデータを取得できる' do
      allow(Rails.root).to receive(:join).and_return(csv_path)
      ingredients = Ingredient.all

      expect(ingredients.size).to eq(2)
      expect(ingredients.first.name).to eq('豆腐')
      expect(ingredients.first.calories).to eq(100.0)
    end

    it '無効なカロリー値のデータをスキップする' do
      File.write(csv_path, "食品名,エネルギー（kcal）\n豆腐,100\n不正なデータ,abc\nわかめ,10\n")
      allow(Rails.root).to receive(:join).and_return(csv_path)

      ingredients = Ingredient.all

      expect(ingredients.size).to eq(2) # 無効な行が 1 つあるので 2 件になる
    end
  end
end

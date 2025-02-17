# MisoScore

## プロジェクト概要

MisoScore は、お味噌汁の具材を選択して合計カロリーを計算できるシンプルな Web アプリです。データベースを使用せず、CSV ファイルから具材情報を読み込んで表示します。

## セットアップ方法

### 必要な環境

- Ruby 3.x
- Rails 7.1.0

### インストール手順

```sh
# リポジトリをクローン
git clone https://github.com/your-repository/misoscore.git
cd misoscore

# 必要なGemをインストール
bundle install

# サーバー起動
rails server
```

## アプリの使い方

1. トップページでお味噌汁の具材を選択する
2. 「計算する」ボタンを押す
3. カロリー計算結果画面で合計カロリーを確認する
4. 「再選択する」ボタンでトップページに戻る

## CSV データフォーマット

具材データは `db/Ingredients.csv` に格納され、以下のフォーマットで記述します。

```
食品名,エネルギー（kcal）
豆腐,56
わかめ,12
大根,18
```

※ カラム名は「食品名」と「エネルギー（kcal）」が必須です。

## 技術スタック

- Ruby on Rails 7.1.0
- ERB（テンプレートエンジン）
- HTML / CSS（シンプルなデザイン）

## ソースコード解説

### 1. CSV データの読み込み

`app/models/ingredient.rb` では、`db/Ingredients.csv` から具材データを読み込み、オブジェクトとして管理します。

```ruby
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
      ingredients << Ingredient.new(name, calories) if name && calories
    end

    ingredients
  end
end
```

#### 説明

- `CSV.foreach` を使用して CSV データを行ごとに読み込みます。
- `Ingredient.new` でオブジェクト化し、リストに格納します。
- 必要なデータのみを配列 `ingredients` に保存し、取得できるようにします。

### 2. カロリー計算

`app/controllers/ingredients_controller.rb` の `calculate` メソッドでは、選択した具材のカロリー合計を計算します。

```ruby
def calculate
  selected_names = params[:ingredients] || []
  @selected_ingredients = Ingredient.all.select { |ing| selected_names.include?(ing.name) }
  @total_calories = @selected_ingredients.sum(&:calories)
  render 'calculate'
end
```

#### 説明

- フォームから受け取った具材名のリストを `selected_names` に格納します。
- `Ingredient.all` から、選択された具材のみを `@selected_ingredients` に抽出します。
- `sum(&:calories)` で合計カロリーを計算します。

### 3. バリデーションの実装

バリデーションを追加することで、データの整合性を確保します。`app/models/ingredient.rb` では、具材名とカロリーのバリデーションを設定しています。

```ruby
class Ingredient
  include ActiveModel::Model

  attr_accessor :name, :calories

  validates :name, presence: true
  validates :calories, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
```

#### 説明

- `ActiveModel::Model` を利用し、バリデーションを適用できるようにします。
- `validates :name, presence: true` で、具材名が空でないことを保証します。
- `validates :calories, presence: true, numericality: { greater_than_or_equal_to: 0 }` で、カロリーが数値であり、0 以上であることを確認します。

このようにして、アプリのデータが正しく管理されるように設計されています。

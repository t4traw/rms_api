# RmsItemApi

[![Build Status](https://travis-ci.org/t4traw/rms_item_api.svg?branch=master)](https://travis-ci.org/t4traw/rms_item_api)

楽天市場に出店している店舗が使えるRMSの商品APIを叩くためのrubyラッパーです。シンプルなCRUD(作成、取得、更新、削除)のみを実装してあります。検索と複数更新は必要があれば追加したいと思います。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rms_item_api'
```
## Usage

取得や更新する項目に関しては楽天RMS WEB APIのドキュメント「拡張サービス一覧＞WEB APIサービス＞RMS WEB SERVICE : ItemAPI」(要ログイン)にて。

### Initialize

RMS内の「拡張サービス一覧＞WEB APIサービス＞利用設定」にあるserviceSecretとlicenseKeyが必要です(事前にWEB APIの利用申し込みが必要です)。

```ruby
client = RmsItemApi::Client.new(
  serviceSecret: "your_serviceSecret",
  licenseKey: "your_licenseKey"
)
```

### Get

RMSに登録している商品情報を商品管理番号を指定して取得することができます。

```ruby
item = client.get('test123')

# 正常なレスポンスが返ってきているかをtrue/falseで返します
item.is_success?

# 商品名を取得
item.item_name
# 表示価格を取得
item.item_price
# 全ての取得データをhashで出力します
item.all
```

### Insert

RMSに商品情報を登録することができます。

```ruby
item = client.insert({
  item_url: 'test123',
  item_name: 'api_insert_test_item',
  item_price: '298000',
  genreId: 564040,
  images: {
    image: {
      image_url: 'http://image.rakuten.co.jp/your_shop_id/cabinet/test.jpg'
    }
  },
  item_layout: 2,
  is_included_postage: true
})

# 正常なレスポンスが返ってきているかをtrue/falseで返します
item.is_success?
```

### Update

RMSに登録されている商品情報を更新することができます。

```ruby
item = client.update({
  item_url: 'test123',
  item_name: 'api_update_test_item',
  item_price: '198000',
  categories: {
    categoryInfo: {
      categoryId: '0000000123'
    }
  }
})
```

### Delete

RMSに登録されている商品情報を削除することができます。

```ruby
item = client.delete({
  item_url: 'test123',
})
```

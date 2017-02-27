# RmsItemApi

楽天市場に出店している店舗が使えるRMSの商品APIを叩くためのrubyラッパーです。シンプルなCRUD(作成、取得、更新、削除)のみを実装してあります。検索と複数更新は必要があれば追加したいと思います。

## Installation

```
gem install rms_item_api
```
## Usage

取得や更新する項目に関しては楽天RMS WEB APIのドキュメント(要ログイン)にて。
https://webservice.rms.rakuten.co.jp/merchant-portal/view?page=document0002

### Initialize

RMS内の「[拡張サービス一覧＞WEB APIサービス＞利用設定](https://webservice.rms.rakuten.co.jp/merchant-portal/configurationApi)」にあるserviceSecretとlicenseKeyが必要です(事前にWEB APIの利用申し込みが必要)。

```ruby
client = RmsItemApi::RmsItemApi.new(
  serviceSecret: "your_serviceSecret",
  licenseKey: "your_licenseKey"
  )
```

### Get

この機能を利用すると、RMSに登録している商品情報を商品管理番号を指定して取得することができます。

```ruby
item = client.get('test123')

# 商品名を取得
item.item_name
# 表示価格を取得
item.item_price
```

### Insert

この機能を利用すると、RMSに商品情報を登録することができます。

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
```

### Update

この機能を利用すると、RMSに登録されている商品情報を更新することができます。

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

この機能を利用すると、RMSに登録されている商品情報を削除することができます。

```ruby
item = client.delete({
  item_url: 'test123',
  })
```

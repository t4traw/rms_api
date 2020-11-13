# RmsApi

[![Build Status](https://travis-ci.org/t4traw/rms_api.svg?branch=master)](https://travis-ci.org/t4traw/rms_api)
[![Code Climate](https://codeclimate.com/github/t4traw/rms_api/badges/gpa.svg)](https://codeclimate.com/github/t4traw/rms_api)

楽天市場に出店している店舗が使えるRMSのAPIを叩くためのrubyラッパーです。

## 現在対応しているAPI

- Item API（作成、取得、更新、削除）

## Installation

```ruby
gem 'rms_api'
```

## Usage

RMS内の「拡張サービス一覧＞ WEB APIサービス＞利用設定」にあるserviceSecretとlicenseKeyが必要です（事前にWEB APIの利用申し込みが必要です）。

### Initialize

```sh
export RMS_SERVICE_SECRET="YOUR_SERVICE_SECRET"
export RMS_LICENSE_KEY="YOUR_LICENSE_KEY"
```

もしくはconfigureで初期設定ができます。

```ruby
RmsApi.configure do |config|
  config.service_secret = "YOUR_SERVICE_SECRET"
  config.license_key = "YOUR_LICENSE_KEY"
end
```

## Item API

取得や更新する項目に関しては楽天RMS WEB APIのドキュメント「拡張サービス一覧＞ WEB APIサービス＞ RMS WEB SERVICE : ItemAPI」（要ログイン）などを確認してください。

RMSに登録している商品情報を商品管理番号を指定して取得できます。

```ruby
response = RmsApi::Item.get('test123')

# 正常なレスポンスが返ってきているかをtrue/falseで返します
response.is_success?

# 商品名を取得
response.item_name
# 表示価格を取得
response.item_price
# 全ての取得データをhashで出力します
response.all
```

### Insert

RMSに商品情報を登録できます。

```ruby
response = RmsApi::Item.insert({
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/t4traw/rms_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/t4traw/rms_api/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RmsApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/t4traw/rms_api/blob/master/CODE_OF_CONDUCT.md).

require 'rms_item_api'
require 'test_helper'

class RmsItemApiTest < Minitest::Test
  include TestHelper::Client

  def test_item_get
    expect_inventory_data = {
      "itemInventory"=>{
        "inventoryType"=>"1",
        "inventories"=>{
          "inventory"=>{
            "inventoryCount"=>"0",
            "isBackorder"=>"false",
            "isRestoreInventoryFlag"=>"false"
          }
        },
        "inventoryQuantityFlag"=>"0"
      }
    }
    VCR.use_cassette('item/test_item_get') do
      item = client.get('test1234')
      assert_equal true, item.is_success?
      assert_equal 'test_item', item.item_name
      assert_equal expect_inventory_data, item.item_inventory
    end
  end

  def test_item_insert
    insert_data = {
      itemUrl: "test1234",
      itemNumber: "test1234",
      itemName: "test_item",
      itemPrice: 12345,
      genreId: 101916,
      catalogIdExemptionReason: 5,
      descriptionForPC: "Lorem ipsum",
      descriptionForMobile: "Lorem ipsum",
      descriptionForSmartPhone: "Lorem ipsum",
      catchCopyForPC: "",
      catchCopyForMobile: "",
      descriptionBySalesMethod: "Lorem ipsum",
      isSaleButton: true,
      isDocumentButton: false,
      isInquiryButton: true,
      isStockNoticeButton: false,
      itemLayout: 1,
      isIncludedTax: true,
      isIncludedPostage: false,
      isIncludedCashOnDeliveryPostage: false,
      isNoshiEnable: false,
      isUnavailableForSearch: false,
      isDepot: true,
      detailSellType: 0,
      item_inventory: {
        inventory_type: 1,
        inventories: {
          inventory: {
            inventoryCount: 0
          }
        }
      }
    }
    VCR.use_cassette('item/test_item_insert') do
      item = client.insert(insert_data)
      assert_equal true, item.is_success?
    end
  end

  def test_item_insert_error
    insert_data = {
      itemUrl: "test1234",
    }
    expect_errors = [
      "商品管理番号（商品URL）欄にすでに登録済みのものは指定できません。重複がありましたのでご確認ください。",
      "商品名は必須項目です。必ず記入してください。",
      "全商品ディレクトリID欄がありません。登録の場合は、必ず全商品ディレクトリIDをご指定ください。",
      "販売価格欄がありません。登録の場合は、必ず販売価格をご指定ください。",
      "在庫タイプ欄がありません。登録の場合は、必ず在庫タイプをご指定ください。"
    ]
    VCR.use_cassette('item/test_item_insert_error') do
      item = client.insert(insert_data)
      assert_equal false, item.is_success?
      assert_equal expect_errors, item.errors
      assert_equal "不要なデータが入っています。", item.message
    end
  end

  def test_item_update
    update_data = {
      itemUrl: "test1234",
      itemName: "changed_item",
    }
    VCR.use_cassette('item/test_item_update') do
      assert_equal 'test_item', client.get(update_data[:itemUrl]).item_name
      assert_equal true, client.update(update_data).is_success?
      assert_equal 'changed_item', client.get(update_data[:itemUrl]).item_name
    end
  end

end

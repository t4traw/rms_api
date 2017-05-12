require 'rms_item_api'
require 'test_helper'

class RmsItemApiTest < Minitest::Test
  include TestHelper::Client

  def test_item_get
    inventory_data = {
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
      assert_equal inventory_data, item.item_inventory
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

end

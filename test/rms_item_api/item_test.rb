require 'rms_item_api'
require 'test_helper'

class RmsItemApiTest < Minitest::Test
  include TestHelper::Client

  def test_item_get
    expect_inventory_data = {
      'itemInventory' => {
        'inventoryType' => '1',
        'inventories' => {
          'inventory' => {
            'inventoryCount' => '0',
            'isBackorder' => 'false',
            'isRestoreInventoryFlag' => 'false'
          }
        },
        'inventoryQuantityFlag' => '0'
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
      item_url: 'test1234',
      item_number: 'test1234',
      item_name: 'test_item',
      item_price: 12_345,
      genre_id: 101_916,
      catalog_id_exemption_reason: 5,
      description_for_pc: 'Lorem ipsum',
      description_for_mobile: 'Lorem ipsum',
      description_for_smart_phone: 'Lorem ipsum',
      catch_copy_for_pc: '',
      catch_copy_for_mobile: '',
      description_by_sales_method: 'Lorem ipsum',
      is_sale_button: true,
      is_document_button: false,
      is_inquiry_button: true,
      is_stock_notice_button: false,
      item_layout: 1,
      is_included_tax: true,
      is_included_postage: false,
      is_included_cash_on_delivery_postage: false,
      is_noshi_enable: false,
      is_unavailable_for_search: false,
      is_depot: true,
      detail_sell_type: 0,
      item_inventory: {
        inventory_type: 1,
        inventories: {
          inventory: {
            inventory_count: 0
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
      item_url: 'test1234'
    }
    expect_errors = [
      '商品管理番号（商品URL）欄にすでに登録済みのものは指定できません。重複がありましたのでご確認ください。',
      '商品名は必須項目です。必ず記入してください。',
      '全商品ディレクトリID欄がありません。登録の場合は、必ず全商品ディレクトリIDをご指定ください。',
      '販売価格欄がありません。登録の場合は、必ず販売価格をご指定ください。',
      '在庫タイプ欄がありません。登録の場合は、必ず在庫タイプをご指定ください。'
    ]
    VCR.use_cassette('item/test_item_insert_error') do
      item = client.insert(insert_data)
      assert_equal false, item.is_success?
      assert_equal expect_errors, item.errors
      assert_equal '不要なデータが入っています。', item.message
    end
  end

  def test_item_update
    update_data = {
      item_url: 'test1234',
      item_name: 'changed_item'
    }
    VCR.use_cassette('item/test_item_update') do
      assert_equal 'test_item', client.get(update_data[:item_url]).item_name
      assert_equal true, client.update(update_data).is_success?
      assert_equal 'changed_item', client.get(update_data[:item_url]).item_name
    end
  end

  def test_item_delete
    delete_data = {
      item_url: 'test1234'
    }
    VCR.use_cassette('item/test_item_delete') do
      assert_equal true, client.delete(delete_data).is_success?
      item = client.get(delete_data[:item_url])
      assert_equal false, item.is_success?
      assert_equal '該当する商品IDは存在しません。', item.message
    end
  end
end

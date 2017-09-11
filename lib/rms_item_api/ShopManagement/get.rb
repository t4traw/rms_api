module RmsItemApi
  module ShopManagement
    include RmsItemApi::Helper

    def shop_management_get(item_data)
      response = connection('1.0/item/', 'get').get {|r| r.params['itemUrl'] = item_data}
      handler response
    end

  end
end

module RmsItemApi
  module Product
    include RmsItemApi::Helper

    def product_get(item_data)
      response = connection('1.0/item/', 'get').get {|r| r.params['itemUrl'] = item_data}
      handler response
    end

  end
end

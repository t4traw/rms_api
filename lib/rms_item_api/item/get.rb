module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def item_get(item_data)
      response = connection('1.0/item/', 'get').get {|r| r.params['itemUrl'] = item_data}
      handler response
    end

  end
end

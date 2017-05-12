module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def get(item_data)
      result = connection('get').get {|r| r.params['itemUrl'] = item_data}
      handler(result.body, "Get")
    end

  end
end

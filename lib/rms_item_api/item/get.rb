module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def get(item_data)
      result = connection('get').get {|r| r.params['itemUrl'] = item_data}
      check_system_status(result.body, "Get")
    end

  end
end

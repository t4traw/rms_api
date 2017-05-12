module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def get(item_data)
      response = connection('get').get {|r| r.params['itemUrl'] = item_data}
      handler response
    end

  end
end

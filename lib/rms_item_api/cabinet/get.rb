module RmsItemApi
  module Cabinet
    include RmsItemApi::Helper

    def cabinet_usage_get(item_data)
      response = connection('cabinet/usage/', 'get').get {|r| r.params['itemUrl'] = item_data}
      handler response
    end

  end
end

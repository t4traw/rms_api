module RmsApi
  module Item
    include RmsApi::Helper

    def get(item_data)
      response = connection(service: :item, method: :get).get { |r| r.params['itemUrl'] = item_data }
      handler response
    end
  end
end

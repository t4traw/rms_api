module RmsApi
  module Item
    extend RmsApi::Helper

    def get(item_data)
      response = connection(service: :item, method: :get).get { |r| r.params['itemUrl'] = item_data }
      handler response
    end

    module_function :get
  end
end

module RmsApi
  module Item
    extend RmsApi::Helper

    def insert(item_data)
      request_xml = { itemInsertRequest: { item: item_data } }.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection(service: :item, method: :insert).post { |r| r.body = request_xml }
      handler response
    end

    module_function :insert
  end
end

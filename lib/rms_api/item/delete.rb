module RmsApi
  module Item
    extend RmsApi::Helper

    def delete(item_data)
      request_xml = { itemDeleteRequest: { item: item_data } }.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection(service: :item, method: :delete).post { |r| r.body = request_xml }
      handler response
    end

    module_function :delete
  end
end

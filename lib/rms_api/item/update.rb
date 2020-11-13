module RmsApi
  module Item
    include RmsApi::Helper

    def update(item_data)
      request_xml = { itemUpdateRequest: { item: item_data } }.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection(service: :item, method: :update).post { |r| r.body = request_xml }
      handler response
    end
  end
end

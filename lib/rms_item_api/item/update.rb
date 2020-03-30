module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def update(item_data)
      request_xml = { itemUpdateRequest: { item: item_data } }.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection('update').post { |r| r.body = request_xml }
      handler response
    end
  end
end

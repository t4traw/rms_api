module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def item_delete(item_data)
      request_xml = {itemDeleteRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection('1.0/item/', 'delete').post {|r| r.body = request_xml}
      handler response
    end

  end
end

module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def insert(item_data)
      request_xml = {itemInsertRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true)
      result = connection('insert').post {|r| r.body = request_xml}
      handler(result.body, "Insert")
    end

  end
end

module RmsItemApi
  module Category
    include RmsItemApi::Helper

    def category_insert(item_data)
      request_xml = {itemInsertRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection('insert').post {|r| r.body = request_xml}
      handler response
    end

  end
end

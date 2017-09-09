module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def item_insert(item_data)
      request_xml = {itemInsertRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      p "リクエストーーーーーーーーーーーーーーーーーーー"
      p "request_xml = #{request_xml}"
      response = connection('1.0/item/', 'insert').post {|r| r.body = request_xml}
      handler response
    end

  end
end

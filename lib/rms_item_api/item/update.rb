module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def item_update(item_data)
      request_xml = {itemUpdateRequest: {item: item_data}}.to_xml(
        root: 'request', camelize: :lower, skip_types: true
      )
      response = connection('1.0/item/', 'update').post {|r| r.body = request_xml}
      p "レスポンス吐き出すよーーーーーーーーーーーーーーーーーーー"
      p response
      handler response
    end

  end
end

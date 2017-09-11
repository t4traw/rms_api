module RmsItemApi
  module Cabinet
    include RmsItemApi::Helper

    def cabinet_usage_get
      p "cabinet_usage_get動いてるヨーーーーーーーー"
      # request_xml = {itemDeleteRequest: {item: item_data}}.to_xml(
      #   root: 'request', camelize: :lower, skip_types: true
      # )
      p "request_xml = #{request_xml}"
      response = connection('1.0/cabinet/usage/', 'get').get
      handler response
    end

    def cabinet_folders_get(offset, limit)
      p "cabinet_folders_get動いてるヨーーーーーーーー"
      response = connection('1.0/cabinet/folders/', 'get').get {|r| r.params['offset', 'limit'] = offset, limit}
      handler response
    end

  end
end

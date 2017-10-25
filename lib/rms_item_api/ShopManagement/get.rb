module RmsItemApi
  module ShopManagement
    include RmsItemApi::Helper

    def shop_shipping_asuraku_get(delvAreaId)
      response = connection('1.0/shopmngt/shipping/asuraku/', 'get').get {|r| r.params['delvAreaId'] = delvAreaId}
      handler response
    end

  end
end

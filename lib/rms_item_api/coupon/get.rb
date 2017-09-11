module RmsItemApi
  module Coupon
    include RmsItemApi::Helper

    def coupon_get(coupon_code)
      response = connection('1.0/coupon/', 'get').get {|r| r.params['couponCode'] = coupon_code}
      handler response
    end

  end
end

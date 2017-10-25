# module RmsItemApi
#   module Coupon
#     include RmsItemApi::Helper
#
#     def coupon_delete(item_data)
#       request_xml = {itemDeleteRequest: {item: item_data}}.to_xml(
#         root: 'request', camelize: :lower, skip_types: true
#       )
#       response = connection('delete').post {|r| r.body = request_xml}
#       handler response
#     end
#
#   end
# end

module RmsItemApi
  module Item
    include RmsItemApi::Helper

    def item_search(item_name, item_price_from, item_price_to, depot_flg, item_mobile_flg, limited_flg, postage_flg, offset, limit, sort_key, sort_order)
      response = connection('1.0/item/', 'search').get { |r|
        r.params['itemName'] = item_name
        r.params['itemPriceFrom'] = item_price_from
        r.params['itemPriceTo'] = item_price_to
        r.params['itemMobileFlg'] = item_mobile_flg
        r.params['limitedFlg'] = limited_flg
        r.params['postageFlg'] = postage_flg
        r.params['offset'] = offset
        r.params['limit'] = limit
        r.params['sortKey'] = sort_key
        r.params['sortOrder'] = sort_order
      }
      handler response
    end

  end
end

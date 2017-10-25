module RmsItemApi
  module Category
    include RmsItemApi::Helper

    def category_get(item_data)
      response = connection('1.0/categoryapi/shop/category/','get').get { |r| r.params['categoryId'] = item_data }
      handler response
    end

    def categories_get(item_data)
      response = connection('1.0/categoryapi/shop/categories/','get').get {|r| r.params['categorySetManageNumber'] = item_data}
      handler response
    end

    def categorsets_get
      response = connection('1.0/categoryapi/shop/categorsets/','get').get
      handler response
    end

  end
end

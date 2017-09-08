module RmsItemApi
  module Navigation
    include RmsItemApi::Helper

    def navigation_genre_get(item_data)
      response = connection('1.0/navigation/genre/','get').get {|r|r.params['genreId'] = item_data}
      handler response
    end

  end
end

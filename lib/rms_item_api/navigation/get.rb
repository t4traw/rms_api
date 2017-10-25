module RmsItemApi
  module Navigation
    include RmsItemApi::Helper

    def navigation_genre_get(genre_id)
      response = connection('1.0/navigation/genre/','get').get {|r|r.params['genreId'] = genre_id}
      handler response
    end

    def navigation_genre_tag_get(genre_id)
      response = connection('1.0/navigation/genre/tag/','get').get {|r|r.params['genreId'] = genre_id}
      handler response
    end
    
  end
end

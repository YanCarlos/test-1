class AlbumSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name 
    image 
    spotify_url 
    total_tracks 
  ]
end

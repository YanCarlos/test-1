class ArtistSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name 
    image 
    genres 
    popularity 
    spotify_url
  ]
end

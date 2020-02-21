class SongSerializer < ActiveModel::Serializer
  attributes %i[
    name
    preview_url
    spotify_url
    duration_ms
    explicit 
  ]
end

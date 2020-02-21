require 'ffaker'

FactoryBot.define do
  factory :artist do
    name { FFaker::Music.artist }
    image { { 'height': 345, 'width': 344, url: FFaker::Image.url } }
    genres { [FFaker::Music.genre, FFaker::Music.genre, FFaker::Music.genre] }
    popularity { 23 }
    spotify_url { FFaker::InternetSE.http_url }
    spotify_id { FFaker::InternetSE.password }
  end
end

require 'ffaker'

FactoryBot.define do
  factory :album do
    name { FFaker::Music.album }
    image { { 'height': 345, 'width': 344, url: FFaker::Image.url } }
    total_tracks { 10 }
    spotify_url { FFaker::InternetSE.http_url }
    spotify_id { FFaker::InternetSE.password }
  end
end

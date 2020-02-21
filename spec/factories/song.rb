require 'ffaker'

FactoryBot.define do
  factory :song do
    name { FFaker::Music.song }
    spotify_url { FFaker::InternetSE.http_url }
    spotify_id { FFaker::InternetSE.password }
  end
end

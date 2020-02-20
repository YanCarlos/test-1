class Artist < ApplicationRecord
  has_many :albums
  
  serialize :image, Hash
end

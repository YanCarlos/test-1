class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy

  serialize :image, Hash
end

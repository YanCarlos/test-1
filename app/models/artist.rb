class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy

  serialize :image, Hash

  scope :ordered_by_popularity, -> { order(:popularity) }
end

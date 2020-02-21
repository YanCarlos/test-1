class Song < ApplicationRecord
  belongs_to :album

  scope :random_by_genre, -> (genre_name) do
    joins(album: [:artist])
    .where('genres && ?', "{#{genre_name.downcase}}")
    .order('RANDOM()')
    .limit(1)
  end
end

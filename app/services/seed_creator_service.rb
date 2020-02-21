class SeedCreatorService
  attr_reader :error

  def self.for(artist_data)
    new(artist_data)
  end

  def initialize(artist_data)
    @artist_data = artist_data
  end

  def create_seed
    ActiveRecord::Base.transaction do
      begin
        create_artist(@artist_data[:artist])
        @artist_data[:albums_and_songs].each do |album, songs|
          create_album(@created_artist, album)

          songs.each do |song|
            create_song(@created_album, song)
          end
        end

        return true
      rescue StandardError => e
        @error = e.message
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def create_artist(data)
    @created_artist = find_or_initialize(Artist, data)
    @created_artist.attributes = data

    @created_artist.save!
  end

  def create_album(artist, data)
    @created_album = find_or_initialize(Album, data)
    @created_album.artist = artist
    @created_album.attributes = data

    @created_album.save!
  end

  def create_song(album, data)
    @created_song = find_or_initialize(Song, data)
    @created_song.album = album
    @created_song.attributes = data

    @created_song.save!
  end

  def find_or_initialize(klass, data)
    raise ActiveModel::MissingAttributeError if data[:spotify_id].nil?

    klass.find_or_initialize_by(spotify_id:  data[:spotify_id])
  end
end

class SpotifyImporterService
  attr_reader :error, :artist, :albums_count, :songs_count

  def self.for(artist_name)
    new(artist_name)
  end

  def initialize(artist_name)
    @artist_name = artist_name
    @artist = nil
    @error = nil
    @albums_count = 0
    @songs_count = 0
  end

  def import
    begin
      @artist = find_artist(@artist_name)
      return unless @artist

      @albums_and_songs = find_albums_and_songs(@artist)
      @artist = {
        artist: build_artist(@artist),
        albums_and_songs: @albums_and_songs
      }

      return true

    rescue RestClient::TooManyRequests => e
      @error = e.full_message
      puts "entro al TooManyRequests"
      sleep_time = if e.response.headers[:retry_after].present?
                     (e.response.headers[:retry_after]).to_i.seconds + 0.5
                   else
                     0.5
                   end
      puts "The importer is sleeping, wait..."
      sleep(sleep_time)
      retry
    end
  end

  private

  def find_artist(artist_name)
    RSpotify::Artist.search(artist_name).first
  end

  def find_albums_and_songs(artist)
    {}.compare_by_identity.tap do |albums_and_songs|

      albums = artist.albums
      @albums_count += albums.count

      albums.each do |album|
        album_structure = build_album(album)
        albums_and_songs[album_structure] = []

        songs = album.tracks
        @songs_count += songs.count

        songs.each do |song|
          song_structure = build_song(song)
          albums_and_songs[album_structure].push(song_structure)
        end
      end
    end
  end

  def build_artist(artist)
    {
      name: artist.name,
      image: artist.images.first,
      genres: artist.genres,
      popularity: artist.popularity,
      spotify_url: artist.uri,
      spotify_id: artist.id
    }
  end

  def build_album(album)
    {
      name: album.name,
      image: album.images.first,
      total_tracks: album.total_tracks,
      spotify_url: album.uri,
      spotify_id: album.id
    }
  end

  def build_song(song)
    {
      name: song.name,
      preview_url: song.preview_url,
      duration_ms: song.duration_ms,
      explicit: song.explicit,
      spotify_id: song.id,
      spotify_url: song.uri
    }
  end
end

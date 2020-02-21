namespace :rubytify do
  desc 'Importing artists data from spotify and saving it to our db'

  task seed: :environment do
    artists = YAML.load(File.read('lib/artist.yml'))['artists']

    artists.compact.each do |artist_name|
      print_importing(artist_name)

      importer = SpotifyImporterService.for(artist_name)

      if importer.import == false
        an_error_has_ocurred_when_importing(importer.error, artist_name)
        next
      else
        imported_artist = importer.artist
      end
      
      if imported_artist.nil?
        artist_not_found(artist_name)
        next
      else
        print_creating(artist_name, importer)

        creator = SeedCreatorService.for(imported_artist)
        if creator.create_seed
          artist_has_been_created(artist_name)
        else
          an_error_has_ocurred_when_creating(creator.error, artist_name)
        end
      end
    end
  end

  def print_importing(artist_name)
    puts "\nImporting #{artist_name} from spotify, please wait..."
  end

  def print_creating(artist_name, imported_artist)
    puts "Saving #{artist_name} to database (albums: #{imported_artist.albums_count}, songs: #{imported_artist.songs_count}), please wait..."
  end

  def artist_not_found(artist_name)
    puts "The artist with name: #{artist_name} is not found."
  end

  def an_error_has_ocurred_when_importing(error, artist_name)
    puts "An error has been arisen from spotify API for artist: #{artist_name}."
    puts "Exception launched for #{artist_name}: #{error}"
  end

  def artist_has_been_created(artist_name)
    puts "The artist with name: #{artist_name} has been saved."
  end

  def an_error_has_ocurred_when_creating(error, artist_name)
    puts "An error has been arisen from SeedCreatorService for artits: #{artist_name}."

    puts "Exception launched: #{error}"
  end
end

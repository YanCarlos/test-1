require 'rails_helper'

describe SeedCreatorService do
  describe '#create_seed' do
    let!(:artist) { FactoryBot.attributes_for(:artist) }
    let!(:album_1) { FactoryBot.attributes_for(:album) }
    let!(:album_2) { FactoryBot.attributes_for(:album) }
    let!(:song_1) { FactoryBot.attributes_for(:song) }
    let!(:song_2) { FactoryBot.attributes_for(:song) }
    let!(:song_3) { FactoryBot.attributes_for(:song) }
    let!(:song_4) { FactoryBot.attributes_for(:song) }
    let!(:song_5) { FactoryBot.attributes_for(:song) }

    let(:service) { SeedCreatorService.for(artist_data) }

    context 'when everything is ok' do
      context 'when none object was created before' do
        let!(:artist_data) {
          {
            artist: artist,
            albums_and_songs: {
              album_1 => [song_1, song_2],
              album_2 => [song_3, song_4, song_5]
            }
          }
        }

        it 'returns a true' do
          expect(service.create_seed).to be(true)
        end

        it 'creates the artist, his album and his song' do
          service.create_seed
          created_artist = Artist.first

          expect(created_artist.name).to eq(artist[:name])
          expect(created_artist.albums.count).to eq(2)
          expect(created_artist.albums.first.songs.count).to eq(2)
          expect(created_artist.albums.last.songs.count).to eq(3)
        end
      end

      context 'when artist is repeated or it was created before' do
        before do
          FactoryBot.create(:artist, artist)
        end

        let!(:artist_data) {
          {
            artist: artist,
            albums_and_songs: {
              album_1 => [song_3, song_4, song_5],
              album_2 => [song_1, song_2]
            }
          }
        }

        it 'returns a true' do
          expect(service.create_seed).to be(true)
        end

        it 'updates the artist and creates his albums and songs' do
          service.create_seed
          created_artist = Artist.first

          expect(Artist.count).to eq(1)
          expect(created_artist.name).to eq(artist[:name])
          expect(created_artist.albums.count).to eq(2)
          expect(created_artist.albums.first.songs.count).to eq(3)
        end
      end
    end

    context 'when something was wrong' do
      context 'spotify_id of artist is missing' do
        let!(:artist_data) {
          {
            artist: { name: 'grupo niche' },
            albums_and_songs: {
              album_1 => [song_3, song_4, song_5],
              album_2 => [song_1, song_2]
            }
          }
        }

        it 'does not return true' do
          expect(service.create_seed).not_to be(true)
        end

        it 'return a MissingAttribute error' do
          service.create_seed

          expect(service.error).to eq('ActiveModel::MissingAttributeError')
        end
      end
    end
  end
end

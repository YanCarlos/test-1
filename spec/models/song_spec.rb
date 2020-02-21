require 'rails_helper'

describe Song do
  it { should belong_to(:album) }

  describe 'scopes' do
    describe '#random_by_genre' do
      let!(:vallenato_artist) {
        FactoryBot.create(:artist, genres: ['vallenato', 'champeta']) 
      }
      let!(:vallenato_album) { 
        FactoryBot.create(:album, artist: vallenato_artist) 
      }
      let!(:vallenato_songs) { 
        FactoryBot.create_list(:song, 5, album: vallenato_album) 
      }

      let!(:salsa_artist) { 
        FactoryBot.create(:artist, genres: ['salsa', 'latina']) 
      }
      let!(:salsa_album) { FactoryBot.create(:album, artist: salsa_artist) }
      let!(:salsa_songs) { 
        FactoryBot.create_list(:song, 5, album: salsa_album) 
      }

      context 'searching salsa music' do
        let!(:found_song) { described_class.random_by_genre('salsa')[0] }

        it 'returns a song of salsa genre' do
          expect(salsa_songs).to include(found_song)
          expect(vallenato_songs).not_to include(found_song)
        end
      end

      context 'searching vallenato music' do
        let!(:found_song) { described_class.random_by_genre('vallenato')[0] }

        it 'returns a song of vallenato genre' do
          expect(salsa_songs).not_to include(found_song)
          expect(vallenato_songs).to include(found_song)
        end
      end

      context 'searching a genre that not exist' do
        let!(:found_song) { described_class.random_by_genre('rock')[0] }

        it 'returns nil' do
          expect(found_song).to be_nil
        end
      end
    end
  end
end

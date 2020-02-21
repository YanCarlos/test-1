require 'rails_helper'

describe Api::V1::GenresController, 'GET#index' do
  let!(:tropical_artist) { FactoryBot.create(:artist, genres: ['tropical']) }
  let!(:tropical_album) { FactoryBot.create(:album, artist: tropical_artist) }
  let!(:tropical_songs) { 
    FactoryBot.create_list(:song, 5, album: tropical_album) 
  }

  let!(:trap_artist) { FactoryBot.create(:artist, genres: ['trap']) }
  let!(:trap_album) { FactoryBot.create(:album, artist: trap_artist) }
  let!(:trap_songs) { FactoryBot.create_list(:song, 10, album: trap_album) }

  context 'searching by trap genre' do
    before do
      get :random_song, params: { genre_name: 'trap' }
    end

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'returns 1 on X-Total-Count' do
      expect(response['X-Total-Count']).to eq(1)
    end

    it 'returns a random song of trap genre' do
      found_song = JSON.parse(response.body)['data']

      is_in_trap_songs = trap_songs.select { |song| 
        song.spotify_url == found_song['spotify_url'] && 
        song.name == found_song['name']
      }.present?

      is_in_tropical_songs = tropical_songs.select { |song| 
        song.spotify_url == found_song['spotify_url'] && 
        song.name == found_song['name']
      }.present?

      expect(is_in_trap_songs).to eq(true)
      expect(is_in_tropical_songs).to eq(false)
    end
  end

  context 'searching by genre that not exist' do
    before do
      get :random_song, params: { genre_name: 'merecumbe' }
    end

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'returns 0 on X-Total-Count' do
      expect(response['X-Total-Count']).to eq(0)
    end

    it 'return a empty object' do
      found_song = JSON.parse(response.body)['data']

      expect(found_song).to eq({})
    end
  end
end

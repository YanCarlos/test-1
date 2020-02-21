require 'rails_helper'

describe Api::V1::SongsController, 'GET#index' do
  let!(:artist) { FactoryBot.create(:artist) }
  let!(:album) { FactoryBot.create(:album, artist: artist) }

  before do
    FactoryBot.create_list(:song, 15, album: album)
  end

  context 'when the album exists' do
    before do
      get :index, params: { id: album.id }
    end

    it 'returns a status 200' do
      expect(response.status).to eq(200)
    end

    it 'returns songs count on X-Total-Count' do
      expect(response['X-Total-Count']).to eq(15)
    end

    it 'retrieves all songs' do
      albums_count = JSON.parse(response.body)['data'].count

      expect(albums_count).to eq(15)
    end
  end

  context 'when the album does not exist' do
    before do
      get :index, params: { id: 50 }
    end

    it 'returns a status 404 not found' do
      expect(response.status).to eq(404)
    end

    it 'returns an error message' do
      error_message = JSON.parse(response.body)['data']['message']

      expect(error_message).to eq("Couldn't find Album with 'id'=50")
    end
  end

  context 'validating expected attributes for songs' do

    before do
      get :index, params: { id: album.id }
    end

    let!(:song) { JSON.parse(response.body)['data'].first }

    it 'does not return id of the song' do
      expect(song.key?('id')).to be(false)
    end

    it 'returns name of the song' do
      expect(song.key?('name')).to be(true)
    end

    it 'returns preview_url of the song' do
      expect(song.key?('preview_url')).to be(true)
    end

    it 'returns spotify_url of the song' do
      expect(song.key?('spotify_url')).to be(true)
    end

    it 'returns duration_ms of the song' do
      expect(song.key?('duration_ms')).to be(true)
    end

    it 'returns explicit of the song' do
      expect(song.key?('explicit')).to be(true)
    end

    it 'doest not return spotify_id of the song' do
      expect(song.key?('spotify_id')).to be(false)
    end
  end
end

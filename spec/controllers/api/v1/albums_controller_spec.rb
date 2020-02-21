require 'rails_helper'

describe Api::V1::AlbumsController, 'GET#index' do
  let!(:artist) { FactoryBot.create(:artist) }

  before do
    FactoryBot.create_list(:album, 10, artist: artist)
  end

  context 'when the artist exists' do
    before do
      get :index, params: { id: artist.id }
    end

    it 'returns a status 200' do
      expect(response.status).to eq(200)
    end

    it 'returns albums count on X-Total-Count' do
      expect(response['X-Total-Count']).to eq(10)
    end

    it 'retrieves all albums' do
      albums_count = JSON.parse(response.body)['data'].count

      expect(albums_count).to eq(10)
    end
  end

  context 'when the artist does not exist' do
    before do
      get :index, params: { id: 1000 }
    end

    it 'returns a status 404 not found' do
      expect(response.status).to eq(404)
    end

    it 'returns an error message' do
      error_message = JSON.parse(response.body)['data']['message']

      expect(error_message).to eq("Couldn't find Artist with 'id'=1000")
    end
  end

  context 'validating expected attributes for albums' do

    before do
      get :index, params: { id: artist.id }
    end

    let!(:album) { JSON.parse(response.body)['data'].first }

    it 'returns id of the album' do
      expect(album.key?('id')).to be(true)
    end

    it 'returns name of the album' do
      expect(album.key?('name')).to be(true)
    end

    it 'returns image of the album' do
      expect(album.key?('image')).to be(true)
    end

    it 'returns total_tracks of the album' do
      expect(album.key?('total_tracks')).to be(true)
    end

    it 'returns spotify_url of the album' do
      expect(album.key?('spotify_url')).to be(true)
    end

    it 'doest not return spotify_id of the album' do
      expect(album.key?('spotify_id')).to be(false)
    end
  end
end

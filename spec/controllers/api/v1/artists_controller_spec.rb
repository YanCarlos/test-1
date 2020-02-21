require 'rails_helper'

describe Api::V1::ArtistsController, 'GET#index' do

  before do
    FactoryBot.create_list(:artist, 8)
  end

  before do
    get :index
  end

  it 'returns a status 200' do
    expect(response.status).to eq(200)
  end

  it 'returns artists count on X-Total-Count' do
    expect(response['X-Total-Count']).to eq(8)
  end

  it 'retrieves all artists (8)' do
    artists_count = JSON.parse(response.body)['data'].count

    expect(artists_count).to eq(8)
  end

  context 'validating expected attributes for artists' do
    let!(:artist) { JSON.parse(response.body)['data'].first }

    it 'returns id of the artist' do
      expect(artist.key?('id')).to be(true)
    end

    it 'returns name of the artist' do
      expect(artist.key?('name')).to be(true)
    end

    it 'returns image of the artist' do
      expect(artist.key?('image')).to be(true)
    end

    it 'returns genres of the artist' do
      expect(artist.key?('genres')).to be(true)
    end

    it 'returns popularity of the artist' do
      expect(artist.key?('popularity')).to be(true)
    end

    it 'returns spotify_url of the artist' do
      expect(artist.key?('spotify_url')).to be(true)
    end

    it 'doest not return spotify_id of the artist' do
      expect(artist.key?('spotify_id')).to be(false)
    end
  end
end

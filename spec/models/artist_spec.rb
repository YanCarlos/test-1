require 'rails_helper'

describe Artist do
  it { should have_many(:albums) }

  describe 'scopes' do
    describe '#ordered_by_popularity' do
      before do
        FactoryBot.create(:artist, popularity: 95)
        FactoryBot.create(:artist, popularity: 34)
        FactoryBot.create(:artist, popularity: 58)
      end

      it 'returns artists ordered by popularity' do
        artists = described_class.ordered_by_popularity

        expect(artists.pluck(:popularity)).to eq([34, 58, 95])
      end
    end
  end
end

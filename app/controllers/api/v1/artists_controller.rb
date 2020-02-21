module Api
  module V1
    class ArtistsController < BaseController
      before_action :set_artists, only: :index

      def index
        json_response(@artists, @artists.count, :ok)
      end

      private

      def set_artists
        @artists = Artist.ordered_by_popularity
      end
    end
  end
end
